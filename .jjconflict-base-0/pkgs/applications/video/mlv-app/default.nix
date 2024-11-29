{ fetchFromGitHub
, lib
, mkDerivation
, qmake
, qtbase
, qtmultimedia
, stdenv
}:

mkDerivation rec {
  pname = "mlv-app";
  version = "1.14";

  src = fetchFromGitHub {
    owner = "ilia3101";
    repo = "MLV-App";
    rev = "QTv${version}";
    sha256 = "sha256-RfZXHmWSjZBxNFwQ/bzHppsLS0LauURIdnkAzxAIBcU=";
  };

  patches = lib.optionals stdenv.hostPlatform.isAarch64 [
    # remove optimization flags with x86 only instruction sets
    ./aarch64-flags.patch
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
    platforms = platforms.linux;
    mainProgram = "mlvapp";
  };
}
