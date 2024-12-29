{
  lib,
  mkDerivation,
  extra-cmake-modules,
  kdoctools,
  kinit,
  kcmutils,
  khtml,
  kdesu,
  qtwebengine,
  qtx11extras,
  qtscript,
  qtwayland,
}:

mkDerivation {
  pname = "konqueror";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcmutils
    khtml
    kinit
    kdesu
    qtwebengine
    qtx11extras
    qtscript
    qtwayland
  ];

  # InitialPreference values are too high and any text/html ends up
  # opening konqueror, even if firefox or chromium are also available.
  # Resetting to 1, which is the default.
  postPatch = ''
    substituteInPlace kfmclient_html.desktop \
      --replace InitialPreference=9 InitialPreference=1
  '';

  meta = {
    homepage = "https://apps.kde.org/konqueror/";
    description = "Web browser, file manager and viewer";
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ ];
  };
}
