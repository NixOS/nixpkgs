{ fetchurl, lib, virtualbox }:

with lib;

let
  inherit (virtualbox) version;
in
fetchurl rec {
  name = "Oracle_VM_VirtualBox_Extension_Pack-${version}.vbox-extpack";
  url = "https://download.virtualbox.org/virtualbox/${version}/${name}";
  sha256 =
    # Manually sha256sum the extensionPack file, must be hex!
    # Thus do not use `nix-prefetch-url` but instead plain old `sha256sum`.
    # Checksums can also be found at https://www.virtualbox.org/download/hashes/${version}/SHA256SUMS
    let value = "3c84f0177a47a1969aff7c98e01ddceedd50348f56cc52d63f4c2dd38ad2ca75";
    in assert (builtins.stringLength value) == 64; value;

  meta = {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = "https://www.virtualbox.org/";
    maintainers = with maintainers; [ sander cdepillabout ];
    platforms = [ "x86_64-linux" ];
  };
}
