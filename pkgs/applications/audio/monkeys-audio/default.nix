{ lib
, stdenv
, fetchzip
, cmake
}:

stdenv.mkDerivation rec {
  version = "10.20";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${
      builtins.concatStringsSep "" (lib.strings.splitString "." version)}_SDK.zip";
    sha256 = "sha256-RBrWz0iGVny1YC6H9NJbFb2HhlAxRiFrTBg1Evm85B8=";
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
