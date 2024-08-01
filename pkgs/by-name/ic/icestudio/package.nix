{
  lib,
  appimageTools,
  fetchurl,
}:
appimageTools.wrapType2 rec {
  pname = "icestudio";
  version = "0.12";

  src = fetchurl {
    url = "https://github.com/FPGAwars/icestudio/releases/download/v${version}/icestudio-${version}-linux64.AppImage";
    hash = "sha256-s+hvD+S2f30u8GrYadFOIjexmyicw6bOlFOvyYyjHeE=";
  };
  extraPkgs = pkgs: [ pkgs.python3 ];

  meta = {
    description = "Visual editor for open FPGA boards";
    homepage = "https://github.com/FPGAwars/icestudio";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [
      imadnyc
      jleightcap
      amerino
      rcoeurjoly
    ];
    mainProgram = "icestudio";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
