{
  system ? builtins.currentSystem,
  config ? { },
  pkgs ? import ../.. { inherit system config; },
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  # Hostname can also be set through "hostname" in user-data.
  # This is how proxmox configures hostname through cloud-init.
  metadataDrive = pkgs.stdenv.mkDerivation {
    name = "metadata";
    buildCommand = ''
      mkdir -p $out/iso

      cat << EOF > $out/iso/user-data
      #cloud-config
      hostname: testhostname
      EOF

      cat << EOF > $out/iso/meta-data
      instance-id: iid-local02
      EOF

      ${pkgs.cdrkit}/bin/genisoimage -volid cidata -joliet -rock -o $out/metadata.iso $out/iso
    '';
  };

in
makeTest {
  name = "cloud-init-hostname";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      lewo
      illustris
    ];
  };

  nodes.machine2 =
    { ... }:
    {
      virtualisation.qemu.options = [
        "-cdrom"
        "${metadataDrive}/metadata.iso"
      ];
      services.cloud-init.enable = true;
      networking.hostName = "";
    };

  testScript = ''
    unnamed.wait_for_unit("cloud-final.service")
    assert "testhostname" in unnamed.succeed("hostname")
  '';
}
