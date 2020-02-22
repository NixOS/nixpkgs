{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  metadataDrive = pkgs.stdenv.mkDerivation {
    name = "metadata";
    buildCommand = ''
      mkdir -p $out/iso

      cat << EOF > $out/iso/user-data
      #cloud-config
      write_files:
      -   content: |
                cloudinit
          path: /tmp/cloudinit-write-file
      EOF

      cat << EOF > $out/iso/meta-data
      instance-id: iid-local01
      local-hostname: "test"
      public-keys:
          - "should be a key!"
      EOF
      ${pkgs.cdrkit}/bin/genisoimage -volid cidata -joliet -rock -o $out/metadata.iso $out/iso
      '';
  };
in makeTest {
  name = "cloud-init";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };
  machine =
    { ... }:
    {
      virtualisation.qemu.options = [ "-cdrom" "${metadataDrive}/metadata.iso" ];
      services.cloud-init.enable = true;
    };
  testScript = ''
      machine.start()
      machine.wait_for_unit("cloud-init.service")
      machine.succeed("cat /tmp/cloudinit-write-file | grep -q 'cloudinit'")

      machine.wait_until_succeeds(
          "cat /root/.ssh/authorized_keys | grep -q 'should be a key!'"
      )
  '';
}
