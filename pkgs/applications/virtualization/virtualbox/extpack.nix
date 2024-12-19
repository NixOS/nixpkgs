{
  fetchurl,
  lib,
  virtualbox,
}:
let
  inherit (virtualbox) version;
in
fetchurl rec {
  name = "Oracle_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 =
    # Manually sha256sum the extensionPack file, must be hex!
    # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
    # Checksums can also be found at https://www.virtualbox.org/download/hashes/${version}/SHA256SUMS
    let
      value = "9dd60ef3c52c2a318fbbb6faace5862a299b61f678a579988869865dcf7390b6";
    in
    assert (builtins.stringLength value) == 64;
    value;

  meta = with lib; {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = "https://www.virtualbox.org/";
    maintainers = with maintainers; [
      sander
      friedrichaltheide
    ];
    platforms = [ "x86_64-linux" ];
  };
}
