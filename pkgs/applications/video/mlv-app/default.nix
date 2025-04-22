{
  fetchFromGitHub,
  lib,
  mkDerivation,
  fetchpatch,
  qmake,
  qtbase,
  qtmultimedia,
  stdenv,
}:

mkDerivation rec {
  pname = "mlv-app";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "ilia3101";
    repo = "MLV-App";
    rev = "QTv${version}";
    sha256 = "sha256-boYnIGDowV4yRxdE98U5ngeAwqi5HTRDFh5gVwW/kN8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ilia3101/MLV-App/commit/b7643b1031955f085ade30e27974ddd889a4641f.patch";
      hash = "sha256-DQkoB+fjshWDLzKouhEQXzpqn78WL+eqo5oTfE9ltEk=";
    })
  ];

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin                mlvapp
    install -Dm444 -t $out/share/applications mlvapp.desktop
    install -Dm444 -t $out/share/icons/hicolor/512x512/apps RetinaIMG/MLVAPP.png
    runHook postInstall
  '';

  qmakeFlags = [ "MLVApp.pro" ];

  preConfigure = ''
    export HOME=$TMPDIR
    cd platform/qt/
  '';

  buildInputs = [
    qtmultimedia
    qtbase
  ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/mlvapp"
  '';

  nativeBuildInputs = [
    qmake
  ];

  meta = with lib; {
    description = "All in one MLV processing app that is pretty great";
    homepage = "https://mlv.app";
    license = licenses.gpl3;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mlvapp";
  };
}
