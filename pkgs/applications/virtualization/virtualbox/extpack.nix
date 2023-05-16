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
<<<<<<< HEAD
    let value = "af84dccac488df72bfaeb1eb8c922ba466668561a6ac05c64a7f8b6ebdddbaeb";
=======
    let value = "292961aa8723b54f96f89f6d8abf7d8e29259d94b7de831dbffb9ae15d346434";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    in assert (builtins.stringLength value) == 64; value;

  meta = {
    description = "Oracle Extension pack for VirtualBox";
    license = licenses.virtualbox-puel;
    homepage = "https://www.virtualbox.org/";
<<<<<<< HEAD
    maintainers = with maintainers; [ sander ];
=======
    maintainers = with maintainers; [ sander cdepillabout ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
  };
}
