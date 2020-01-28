{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing.nix { inherit system pkgs; };
with pkgs.lib;

with import common/ec2.nix { inherit makeTest pkgs; };

let
  imageCfg =
    (import ../lib/eval-config.nix {
      inherit system;
      modules = [
        ../maintainers/scripts/ec2/amazon-image.nix
        ../modules/testing/test-instrumentation.nix
        ../modules/profiles/qemu-guest.nix
        { ec2.hvm = true;

          # Hack to make the partition resizing work in QEMU.
          boot.initrd.postDeviceCommands = mkBefore
            ''
              ln -s vda /dev/xvda
              ln -s vda1 /dev/xvda1
            '';

          # Needed by nixos-rebuild due to the lack of network
          # access. Determined by trial and error.
          system.extraDependencies =
            with pkgs; (
              [
                # Needed for a nixos-rebuild.
                busybox
                stdenv
                stdenvNoCC
                mkinitcpio-nfs-utils
                unionfs-fuse
                cloud-utils
                desktop-file-utils
                texinfo
                libxslt.bin
                xorg.lndir

                # These are used in the configure-from-userdata tests
                # for EC2. Httpd and valgrind are requested by the
                # configuration.
                apacheHttpd apacheHttpd.doc apacheHttpd.man valgrind.doc
              ]
            );
        }
      ];
    }).config;
  image = "${imageCfg.system.build.amazonImage}/${imageCfg.amazonImage.name}.vhd";

  sshKeys = import ./ssh-keys.nix pkgs;
  snakeOilPrivateKey = sshKeys.snakeOilPrivateKey.text;
  snakeOilPublicKey = sshKeys.snakeOilPublicKey;

in {
  boot-ec2-nixops = makeEc2Test {
    name         = "nixops-userdata";
    inherit image;
    sshPublicKey = snakeOilPublicKey; # That's right folks! My user's key is also the host key!

    userData = ''
      SSH_HOST_ED25519_KEY_PUB:${snakeOilPublicKey}
      SSH_HOST_ED25519_KEY:${replaceStrings ["\n"] ["|"] snakeOilPrivateKey}
    '';
    script = ''
      $machine->start;
      $machine->waitForFile("/etc/ec2-metadata/user-data");
      $machine->waitForUnit("sshd.service");

      $machine->succeed("grep unknown /etc/ec2-metadata/ami-manifest-path");

      # We have no keys configured on the client side yet, so this should fail
      $machine->fail("ssh -o BatchMode=yes localhost exit");

      # Let's install our client private key
      $machine->succeed("mkdir -p ~/.ssh");

      $machine->succeed("echo '${snakeOilPrivateKey}' > ~/.ssh/id_ed25519");
      $machine->succeed("chmod 600 ~/.ssh/id_ed25519");

      # We haven't configured the host key yet, so this should still fail
      $machine->fail("ssh -o BatchMode=yes localhost exit");

      # Add the host key; ssh should finally succeed
      $machine->succeed("echo localhost,127.0.0.1 ${snakeOilPublicKey} > ~/.ssh/known_hosts");
      $machine->succeed("ssh -o BatchMode=yes localhost exit");

      # Test whether the root disk was resized.
      my $blocks = $machine->succeed("stat -c %b -f /");
      my $bsize = $machine->succeed("stat -c %S -f /");
      my $size = $blocks * $bsize;
      die "wrong free space $size" if $size < 9.7 * 1024 * 1024 * 1024 || $size > 10 * 1024 * 1024 * 1024;

      # Just to make sure resizing is idempotent.
      $machine->shutdown;
      $machine->start;
      $machine->waitForFile("/etc/ec2-metadata/user-data");
    '';
  };

  boot-ec2-config = makeEc2Test {
    name         = "config-userdata";
    inherit image;
    sshPublicKey = snakeOilPublicKey;

    # ### http://nixos.org/channels/nixos-unstable nixos
    userData = ''
      { pkgs, ... }:

      {
        imports = [
          <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
          <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
        ];
        environment.etc.testFile = {
          text = "whoa";
        };

        networking.hostName = "ec2-test-vm"; # required by services.httpd

        services.httpd = {
          enable = true;
          adminAddr = "test@example.org";
          virtualHosts.localhost.documentRoot = "''${pkgs.valgrind.doc}/share/doc/valgrind/html";
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      }
    '';
    script = ''
      $machine->start;

      # amazon-init must succeed. if it fails, make the test fail
      # immediately instead of timing out in waitForFile.
      $machine->waitForUnit('amazon-init.service');

      $machine->waitForFile("/etc/testFile");
      $machine->succeed("cat /etc/testFile | grep -q 'whoa'");

      $machine->waitForUnit("httpd.service");
      $machine->succeed("curl http://localhost | grep Valgrind");
    '';
  };
}
