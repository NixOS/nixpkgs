{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
with pkgs.lib;

let
  image =
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
          # access. Mostly copied from
          # modules/profiles/installation-device.nix.
          system.extraDependencies =
            [ pkgs.stdenv pkgs.busybox pkgs.perlPackages.ArchiveCpio
              pkgs.unionfs-fuse pkgs.mkinitcpio-nfs-utils
            ];
        }
      ];
    }).config.system.build.amazonImage;

  makeEc2Test = { name, userData, script, hostname ? "ec2-instance", sshPublicKey ? null }:
    let
      metaData = pkgs.stdenv.mkDerivation {
        name = "metadata";
        buildCommand = ''
          mkdir -p $out/1.0/meta-data
          ln -s ${pkgs.writeText "userData" userData} $out/1.0/user-data
          echo "${hostname}" > $out/1.0/meta-data/hostname
          echo "(unknown)" > $out/1.0/meta-data/ami-manifest-path
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
          my $imageDir = ($ENV{'TMPDIR'} // "/tmp") . "/vm-state-machine";
          mkdir $imageDir, 0700;
          my $diskImage = "$imageDir/machine.qcow2";
          system("qemu-img create -f qcow2 -o backing_file=${image}/nixos.qcow2 $diskImage") == 0 or die;
          system("qemu-img resize $diskImage 10G") == 0 or die;

          # Note: we use net=169.0.0.0/8 rather than
          # net=169.254.0.0/16 to prevent dhcpcd from getting horribly
          # confused. (It would get a DHCP lease in the 169.254.*
          # range, which it would then configure and prompty delete
          # again when it deletes link-local addresses.) Ideally we'd
          # turn off the DHCP server, but qemu does not have an option
          # to do that.
          my $startCommand = "qemu-kvm -m 768 -net nic,vlan=0,model=virtio -net 'user,vlan=0,net=169.0.0.0/8,guestfwd=tcp:169.254.169.254:80-cmd:${pkgs.micro-httpd}/bin/micro_httpd ${metaData}'";
          $startCommand .= " -drive file=$diskImage,if=virtio,werror=report";
          $startCommand .= " \$QEMU_OPTS";

          my $machine = createMachine({ startCommand => $startCommand });

          ${script}
        '';
    };

  snakeOilPrivateKey = ''
    -----BEGIN OPENSSH PRIVATE KEY-----
    b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
    QyNTUxOQAAACDEPmwZv5dDPrMUaq0dDP+6eBTTe+QNrz14KBEIdhHd1QAAAJDufJ4S7nye
    EgAAAAtzc2gtZWQyNTUxOQAAACDEPmwZv5dDPrMUaq0dDP+6eBTTe+QNrz14KBEIdhHd1Q
    AAAECgwbDlYATM5/jypuptb0GF/+zWZcJfoVIFBG3LQeRyGsQ+bBm/l0M+sxRqrR0M/7p4
    FNN75A2vPXgoEQh2Ed3VAAAADEVDMiB0ZXN0IGtleQE=
    -----END OPENSSH PRIVATE KEY-----
  '';

  snakeOilPublicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQ+bBm/l0M+sxRqrR0M/7p4FNN75A2vPXgoEQh2Ed3V EC2 test key";

in {
  boot-ec2-nixops = makeEc2Test {
    name         = "nixops-userdata";
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
    sshPublicKey = snakeOilPublicKey;

    # ### http://nixos.org/channels/nixos-unstable nixos
    userData = ''
      {
        imports = [
          <nixpkgs/nixos/modules/virtualisation/amazon-image.nix>
          <nixpkgs/nixos/modules/testing/test-instrumentation.nix>
          <nixpkgs/nixos/modules/profiles/qemu-guest.nix>
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
