{ fetchurl, lib, virtualbox }:
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
    let value = "d750fb17688d70e0cb2d7b06f1ad3a661303793f4d1ac39cfa9a54806b89da25";
    in assert (builtins.stringLength value) == 64; value;

  meta = with lib; {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = "https://www.virtualbox.org/";
    maintainers = with maintainers; [ sander friedrichaltheide ];
    platforms = [ "x86_64-linux" ];
  };
}
