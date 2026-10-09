{
  fetchurl,
  lib,
  virtualbox,
}:
fetchurl rec {
  pname = "virtualbox-extpack";
  version = "7.2.20";
  name = "Oracle_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 =
    # Manually sha256sum the extensionPack file, must be hex!
    # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
    # Checksums can also be found at https://download.virtualbox.org/virtualbox/${version}/SHA256SUMS
    let
      value = "0a050da993f2e3cf2e4e9cda2fa8667e44a2b25479b27abd41af6812c1e43591";
    in
    assert (builtins.stringLength value) == 64;
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
