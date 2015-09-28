{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let
  image =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../maintainers/scripts/ec2/amazon-hvm-config.nix
        ../../nixos/modules/testing/test-instrumentation.nix
        { boot.initrd.kernelModules = [ "virtio" "virtio_blk" "virtio_pci" "virtio_ring" ]; }
      ];
    }).config.system.build.amazonImage;

  makeEc2Test = { name, userData, script, hostname ? "ec2-instance", sshPublicKey ? null }:
    let
      metaData = pkgs.stdenv.mkDerivation {
        name = "metadata";
        buildCommand = ''
          mkdir -p $out/2011-01-01
          ln -s ${pkgs.writeText "userData" userData} $out/2011-01-01/user-data
          mkdir -p $out/1.0/meta-data
          echo "${hostname}" > $out/1.0/meta-data/hostname
        '' + optionalString (sshPublicKey != null) ''
          mkdir -p $out/1.0/meta-data/public-keys/0
          ln -s ${pkgs.writeText "sshPublicKey" sshPublicKey} $out/1.0/meta-data/public-keys/0/openssh-key
        '';
      };
    in makeTest {
      name = "ec2-" + name;
      nodes = {};
      testScript =
        ''
          use File::Temp qw/ tempfile /;
          my ($fh, $filename) = tempfile();

          `qemu-img create -f qcow2 -o backing_file=${image}/nixos.img $filename`;

          my $startCommand = "qemu-kvm -m 768 -net nic -net 'user,net=169.254.0.0/16,guestfwd=tcp:169.254.169.254:80-cmd:${pkgs.micro-httpd}/bin/micro_httpd ${metaData}'";
          $startCommand .= " -drive file=" . Cwd::abs_path($filename) . ",if=virtio,werror=report";
          $startCommand .= " \$QEMU_OPTS";

          my $machine = createMachine({ startCommand => $startCommand });
          ${script}
        '';
    };

  snakeOilPrivateKey = [
    "-----BEGIN EC PRIVATE KEY-----"
    "MHcCAQEEIHQf/khLvYrQ8IOika5yqtWvI0oquHlpRLTZiJy5dRJmoAoGCCqGSM49"
    "AwEHoUQDQgAEKF0DYGbBwbj06tA3fd/+yP44cvmwmHBWXZCKbS+RQlAKvLXMWkpN"
    "r1lwMyJZoSGgBHoUahoYjTh9/sJL7XLJtA=="
    "-----END EC PRIVATE KEY-----"
  ];

  snakeOilPublicKey = pkgs.lib.concatStrings [
    "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHA"
    "yNTYAAABBBChdA2BmwcG49OrQN33f/sj+OHL5sJhwVl2Qim0vkUJQCry1zFpKTa"
    "9ZcDMiWaEhoAR6FGoaGI04ff7CS+1yybQ= snakeoil"
  ];
in {
  boot-ec2-nixops = makeEc2Test {
    name         = "nixops-userdata";
    sshPublicKey = snakeOilPublicKey; # That's right folks! My user's key is also the host key!

    userData = ''
      SSH_HOST_DSA_KEY_PUB:${snakeOilPublicKey}
      SSH_HOST_DSA_KEY:${pkgs.lib.concatStringsSep "|" snakeOilPrivateKey}
    '';
    script = ''
      $machine->start;
      $machine->waitForFile("/root/user-data");
      $machine->waitForUnit("sshd.service");

      # We have no keys configured on the client side yet, so this should fail
      $machine->fail("ssh -o BatchMode=yes localhost exit");

      # Let's install our client private key
      $machine->succeed("mkdir -p ~/.ssh");
      ${concatMapStrings (s: "$machine->succeed('echo ${s} >> ~/.ssh/id_ecdsa');") snakeOilPrivateKey}
      $machine->succeed("chmod 600 ~/.ssh/id_ecdsa");

      # We haven't configured the host key yet, so this should still fail
      $machine->fail("ssh -o BatchMode=yes localhost exit");

      # Add the host key; ssh should finally succeed
      $machine->succeed("echo localhost,127.0.0.1 ${snakeOilPublicKey} > ~/.ssh/known_hosts");
      $machine->succeed("ssh -o BatchMode=yes localhost exit");

      $machine->shutdown;
    '';
  };

  boot-ec2-config = makeEc2Test {
    name         = "config-userdata";
    sshPublicKey = snakeOilPublicKey;

    userData = ''
      ### http://nixos.org/channels/nixos-unstable nixos
      {
        imports = [
          <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
          <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
        ];
        environment.etc.testFile = {
          text = "whoa";
        };
      }
    '';
    script = ''
      $machine->start;
      $machine->waitForFile("/etc/testFile");
      $machine->succeed("cat /etc/testFile | grep -q 'whoa'");
    '';
  };
}
