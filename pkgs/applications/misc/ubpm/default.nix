{ stdenv, lib, fetchFromGitea, qmake, qttools, qtbase, qtserialport
, qtconnectivity, qtcharts, wrapQtAppsHook }:

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

  patches = [ ./install.patch ];

  preConfigure = ''
    cd ./sources/
  '';

  postFixup = ''
    wrapQtApp $out/bin/ubpm
  '';

  nativeBuildInputs = [ qmake qttools wrapQtAppsHook ];

  # *.so plugins are being wrapped automatically which breaks them
  dontWrapQtApps = true;

  buildInputs = [ qtbase qtserialport qtconnectivity qtcharts ];

  meta = with lib; {
    homepage = "https://codeberg.org/LazyT/ubpm";
    description = "Universal Blood Pressure Manager";
    mainProgram = "ubpm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ kurnevsky ];
  };
})
