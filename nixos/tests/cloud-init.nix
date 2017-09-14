{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with import ../lib/qemu-flags.nix;
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
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };
  machine =
    { config, pkgs, ... }:
    {
      virtualisation.qemu.options = [ "-cdrom" "${metadataDrive}/metadata.iso" ];
      services.cloud-init.enable = true;
    };
  testScript = ''
     $machine->start;
     $machine->waitForUnit("cloud-init.service");
     $machine->succeed("cat /tmp/cloudinit-write-file | grep -q 'cloudinit'");

     $machine->waitUntilSucceeds("cat /root/.ssh/authorized_keys | grep -q 'should be a key!'");
  '';
}
