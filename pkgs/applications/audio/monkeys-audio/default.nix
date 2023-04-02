{ lib
, stdenv
, fetchzip
, cmake
}:

stdenv.mkDerivation rec {
  version = "9.20";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${
      builtins.concatStringsSep "" (lib.strings.splitString "." version)}_SDK.zip";
    sha256 = "sha256-8cJ88plR9jrrLdzRHzRotGBrn6qIqOWvl+oOTXxY/TE=";
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
