{ pkgs, makeTest }:

with pkgs.lib;

{
  makeEc2Test = { name, image, userData, script, hostname ? "ec2-instance", sshPublicKey ? null, meta ? {} }:
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
      indentLines = str: concatLines (map (s: "  " + s) (splitString "\n" str));
    in makeTest {
      name = "ec2-" + name;
      nodes = {};
      testScript = ''
        import os
        import subprocess
        import tempfile

        image_dir = os.path.join(
            os.environ.get("TMPDIR", tempfile.gettempdir()), "tmp", "vm-state-machine"
        )
        os.makedirs(image_dir, mode=0o700, exist_ok=True)
        disk_image = os.path.join(image_dir, "machine.qcow2")
        subprocess.check_call(
            [
                "qemu-img",
                "create",
                "-f",
                "qcow2",
                "-F",
                "qcow2",
                "-o",
                "backing_file=${image}",
                disk_image,
            ]
        )
        subprocess.check_call(["qemu-img", "resize", disk_image, "10G"])

        # Note: we use net=169.0.0.0/8 rather than
        # net=169.254.0.0/16 to prevent dhcpcd from getting horribly
        # confused. (It would get a DHCP lease in the 169.254.*
        # range, which it would then configure and promptly delete
        # again when it deletes link-local addresses.) Ideally we'd
        # turn off the DHCP server, but qemu does not have an option
        # to do that.
        start_command = (
            "qemu-kvm -m 1024"
            + " -device virtio-net-pci,netdev=vlan0"
            + " -netdev 'user,id=vlan0,net=169.0.0.0/8,guestfwd=tcp:169.254.169.254:80-cmd:${pkgs.micro-httpd}/bin/micro_httpd ${metaData}'"
            + f" -drive file={disk_image},if=virtio,werror=report"
            + " $QEMU_OPTS"
        )

        machine = create_machine({"startCommand": start_command})
        try:
      '' + indentLines script + ''
        finally:
          machine.shutdown()
      '';

      inherit meta;
    };
}
