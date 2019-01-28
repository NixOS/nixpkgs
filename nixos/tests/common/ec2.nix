{ pkgs, makeTest }:

with pkgs.lib;

{
  makeEc2Test = { name, image, userData, script, hostname ? "ec2-instance", sshPublicKey ? null }:
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
          my $startCommand = "qemu-kvm -m 768";
          $startCommand .= " -device virtio-net-pci,netdev=vlan0";
          $startCommand .= " -netdev 'user,id=vlan0,net=169.0.0.0/8,guestfwd=tcp:169.254.169.254:80-cmd:${pkgs.micro-httpd}/bin/micro_httpd ${metaData}'";
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
}
