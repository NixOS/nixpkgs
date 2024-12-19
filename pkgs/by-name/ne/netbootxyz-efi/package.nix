{
  lib,
  fetchurl,
}:

let
  pname = "netboot.xyz-efi";
  version = "2.0.82";
in
fetchurl {
  name = "${pname}-${version}";

  url = "https://github.com/netbootxyz/netboot.xyz/releases/download/${version}/netboot.xyz.efi";
  sha256 = "sha256-cO8MCkroQ0s/j8wnwwIWfnxEvChLeOZw+gD4wrYBAog=";

  meta = with lib; {
    homepage = "https://netboot.xyz/";
    description = "Tool to boot OS installers and utilities over the network, to be run from a bootloader";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
