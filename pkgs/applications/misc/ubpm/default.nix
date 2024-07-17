{
  stdenv,
  lib,
  fetchFromGitea,
  qmake,
  qttools,
  qtbase,
  qtserialport,
  qtconnectivity,
  qtcharts,
  wrapQtAppsHook,
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ubpm";
  version = "1.10.0";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "LazyT";
    repo = "ubpm";
    rev = finalAttrs.version;
    hash = "sha256-BUUn1WyLT7nm4I+2SpO1ZtIf8isGDy8Za15SiO7sXL8=";
  };

  patches = [
    # fixes qmake for nix
    (fetchpatch {
      url = "https://codeberg.org/LazyT/ubpm/commit/f18841d6473cab9aa2a9d4c02392b8e103245ef6.diff";
      hash = "sha256-lgXWu8PUUCt66btj6hVgOFXz3U1BJM3ataSo1MpHkfU=";
    })
  ];

  preConfigure = ''
    cd ./sources/
  '';

  postFixup = ''
    wrapQtApp $out/bin/ubpm
  '';

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ];

  # *.so plugins are being wrapped automatically which breaks them
  dontWrapQtApps = true;

  buildInputs = [
    qtbase
    qtserialport
    qtconnectivity
    qtcharts
  ];

  meta = with lib; {
    homepage = "https://codeberg.org/LazyT/ubpm";
    description = "Universal Blood Pressure Manager";
    mainProgram = "ubpm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kurnevsky ];
    broken = stdenv.isDarwin;
  };
})
