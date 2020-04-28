{ lib
, mkDerivation
, extra-cmake-modules, kdoctools
, kdelibs4support, kcmutils, khtml, kdesu
, qtwebkit, qtwebengine, qtx11extras, qtscript, qtwayland
}:

mkDerivation {
  name = "konqueror";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kdelibs4support kcmutils khtml kdesu
    qtwebkit qtwebengine qtx11extras qtscript qtwayland
  ];

  # InitialPreference values are too high and any text/html ends up
  # opening konqueror, even if firefox or chromium are also available.
  # Resetting to 1, which is the default.
  postPatch = ''
    substituteInPlace kfmclient_html.desktop \
      --replace InitialPreference=9 InitialPreference=1
  '';

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = with lib.maintainers; [ ];
  };
}
