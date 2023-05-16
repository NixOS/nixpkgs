{ lib
, stdenv
, fetchzip
, cmake
}:

stdenv.mkDerivation rec {
<<<<<<< HEAD
  version = "10.20";
=======
  version = "10.11";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${
      builtins.concatStringsSep "" (lib.strings.splitString "." version)}_SDK.zip";
<<<<<<< HEAD
    sha256 = "sha256-RBrWz0iGVny1YC6H9NJbFb2HhlAxRiFrTBg1Evm85B8=";
=======
    sha256 = "sha256-sA1JXRbyHMHBCsWau9GrlxeRiCzxZfCTuLFebZmIoRE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    stripRoot = false;
  };
  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "APE codec and decompressor";
    platforms = platforms.linux;
    # This is not considered a GPL license, but it seems rather free although
    # it's not standard, see a quote of it:
    # https://github.com/NixOS/nixpkgs/pull/171682#issuecomment-1120260551
    license = licenses.free;
    maintainers = with maintainers; [ doronbehar ];
  };
}
