{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 rec {
  pname = "gridtracker";
  version = "2.250421.1";
  src = fetchurl {
    url = "https://download2.gridtracker.org/GridTracker2-${version}-x86_64.AppImage";
    sha256 = "sha256-nb/V50Ds+UojTEHTWeYLg2iI8quU15lcsgtEKdkiTpw=";
  };

  meta = with lib; {
    description = "Amateur radio companion to WSJT-X or JTDX";
    mainProgram = "gridtracker";
    longDescription = ''
      GridTracker listens to traffic from WSJT-X/JTDX, displays it on a map,
      and has a sophisticated alerting and filtering system for finding and
      working interesting stations. It also will upload QSO records to multiple
      logging frameworks including Logbook of the World.
    '';
    homepage = "https://gridtracker.org";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      melling
      sciencemarc
    ];
  };
}
