{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  libsForQt5,
  writableTmpDirAsHomeHook,
  ffmpeg-headless,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlv-app";
  version = "1.15";

  src = fetchFromGitHub {
    owner = "ilia3101";
    repo = "MLV-App";
    rev = "QTv${finalAttrs.version}";
    hash = "sha256-boYnIGDowV4yRxdE98U5ngeAwqi5HTRDFh5gVwW/kN8=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/ilia3101/MLV-App/commit/b7643b1031955f085ade30e27974ddd889a4641f.patch";
      hash = "sha256-DQkoB+fjshWDLzKouhEQXzpqn78WL+eqo5oTfE9ltEk=";
    })
  ];

  postPatch = ''
    substituteInPlace platform/qt/MainWindow.cpp \
      --replace-fail '"ffmpeg"' '"${lib.getExe ffmpeg-headless}"'
  '';

  qmakeFlags = [ "MLVApp.pro" ];

  preConfigure = ''
    cd platform/qt/
  '';

  nativeBuildInputs = [
    libsForQt5.wrapQtAppsHook
    libsForQt5.qmake
    writableTmpDirAsHomeHook
  ];
  buildInputs = [
    libsForQt5.qtmultimedia
    libsForQt5.qtbase
  ];

  dontWrapQtApps = true;

  preFixup = ''
    wrapQtApp "$out/bin/mlvapp"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm555 -t $out/bin                mlvapp
    install -Dm444 -t $out/share/applications mlvapp.desktop
    install -Dm444 -t $out/share/icons/hicolor/512x512/apps RetinaIMG/MLVAPP.png
    runHook postInstall
  '';

  updateScript = nix-update-script { };

  meta = {
    description = "All in one MLV processing app that is pretty great";
    homepage = "https://mlv.app";
    downloadPage = "https://github.com/ilia3101/MLV-App";
    changelog = "https://github.com/ilia3101/MLV-App/releases/tag/QTv${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mlvapp";
  };
})
