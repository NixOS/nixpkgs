{
  fetchurl,
  lib,
  virtualbox,
}:
fetchurl rec {
  pname = "virtualbox-extpack";
  version = "7.2.22";
  name = "Oracle_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  hash =
    # Manually sha256sum the extensionPack file, must be converted to SRI!
    # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`,
    # and convert with `nix-hash --type sha256 --to-sri`
    # Checksums can also be found at https://download.virtualbox.org/virtualbox/${version}/SHA256SUMS
    let
      value = "sha256-zV+zLKxZFX3DYckL5ozO8UBIMarEjsg3dWliCvvJ0gc=";
    in
    assert (builtins.stringLength value) == 51;
    value;

  meta = {
    description = "Oracle Extension pack for VirtualBox";
    license = lib.licenses.virtualbox-puel;
    homepage = "https://www.virtualbox.org/";
    maintainers = with lib.maintainers; [
      friedrichaltheide
    ];
    platforms = [ "x86_64-linux" ];
  };
}
