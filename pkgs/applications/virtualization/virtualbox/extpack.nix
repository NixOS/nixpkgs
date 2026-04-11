{
  fetchurl,
  lib,
  virtualbox,
}:
fetchurl rec {
  pname = "virtualbox-extpack";
  version = "7.2.6";
  name = "Oracle_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 =
    # Manually sha256sum the extensionPack file, must be hex!
    # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
    # Checksums can also be found at https://download.virtualbox.org/virtualbox/${version}/SHA256SUMS
    let
      value = "d46449366b23417a626439785f23f7eaf06bfbfd2cb030713e1abfa5b03d4205";
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
