{
  lib,
  stdenvNoCC,
  curl,
  unrar-wrapper,
}:

stdenvNoCC.mkDerivation {
  pname = "facetimehd-calibration";
  version = "5.1.5769";

  # This is a special sort of fixed-output derivation
  outputHash = "sha256-KQBIlpa68wjQNgBiEnLtl6iEYseNrTlSdq9wiNni16k=";
  outputHashMode = "recursive";

  __structuredAttrs = true;
  builder = ./builder.sh;

  nativeBuildInputs = [
    curl
    unrar-wrapper
  ];

  meta = {
    description = "facetimehd calibration";
    homepage = "https://support.apple.com/kb/DL1837";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      alexshpilkin
      womfoo
      grahamc
    ];
    platforms = lib.platforms.all;
    sourceProvenance = with lib.sourceTypes; [ binaryFirmware ];
  };
}
