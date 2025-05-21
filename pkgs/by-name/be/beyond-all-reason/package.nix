{
  lib,
  fetchurl,
  appimageTools,
  openal,
}:
let
  version = "1.2988.0";
  pname = "beyond-all-reason";

  src = fetchurl {
    url = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/download/v${version}/Beyond-All-Reason-${version}.AppImage";
    hash = "sha256-ZJW5BdxxqyrM2TJTO0SBp4BXt3ILyi77EZx73X8hqJE=";
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ openal ];

  meta = {
    homepage = "https://www.beyondallreason.info/";
    downloadPage = "https://www.beyondallreason.info/download";
    changelog = "https://github.com/beyond-all-reason/BYAR-Chobby/releases/tag/v${version}";
    description = "Free Real Time Strategy Game with a grand scale and full physical simulation in a sci-fi setting";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      kiyotoko
    ];
  };
}
