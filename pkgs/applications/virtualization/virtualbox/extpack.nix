{stdenv, fetchurl, lib}:

with lib;

let version = "6.0.6";
in
fetchurl rec {
  name = "Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 =
    # Manually sha256sum the extensionPack file, must be hex!
    # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
    let value = "794f023a186bd217c29c3d30bd1434b6e9de3b242c7bf740d06d10f2d3d981c6";
    in assert (builtins.stringLength value) == 64; value;

  meta = {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = https://www.virtualbox.org/;
    maintainers = with maintainers; [ flokli sander cdepillabout ];
    platforms = [ "x86_64-linux" ];
  };
}
