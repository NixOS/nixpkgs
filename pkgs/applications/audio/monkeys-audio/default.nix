{ lib
, stdenv
, fetchzip
, cmake
}:

stdenv.mkDerivation (finalAttrs: {
  version = "10.43";
  pname = "monkeys-audio";

  src = fetchzip {
    url = "https://monkeysaudio.com/files/MAC_${
      builtins.concatStringsSep "" (lib.strings.splitString "." finalAttrs.version)}_SDK.zip";
    sha256 = "sha256-Y1X0KWf87L8Qjx/G6/RV37iiN7enwXTAaqQ+45FfTT4=";
    stripRoot = false;
  };
  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "APE codec and decompressor";
    platforms = platforms.linux;
    mainProgram = "mac";
    # This is not considered a GPL license, but it seems rather free although
    # it's not standard, see a quote of it:
    # https://github.com/NixOS/nixpkgs/pull/171682#issuecomment-1120260551
    license = licenses.free;
    maintainers = with maintainers; [ doronbehar ];
  };
})
