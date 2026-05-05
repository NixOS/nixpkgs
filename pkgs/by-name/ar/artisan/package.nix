{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  python3,
  makeWrapper,
  qt6,
  makeDesktopItem,
  libusb1,
  libphidget22,
  libphidget22extra,
}:

let
  version = "4.0.2";
  pname = "artisan";

  pythonEnv = python3.withPackages (
    ps: with ps; [
      phidget22
      yoctopuce
      pyserial
      pymodbus
      python-snap7
      python-statemachine
      unidecode
      qrcode
      requests
      requests-file
      pyusb
      portalocker
      xlrd
      websockets
      pyyaml
      psutil
      typing-extensions
      protobuf
      numpy
      scipy
      openpyxl
      keyring
      prettytable
      lxml
      matplotlib
      colorspacious
      jinja2
      aiohttp
      aiohttp-jinja2
      python-bidi
      arabic-reshaper
      pillow
      pydantic
      babel
      bleak
      pyqt6
      pyqt6-webengine
      distro
      secretstorage
    ]
  );
in
stdenv.mkDerivation {
  inherit version pname;

  src = fetchFromGitHub {
    owner = "artisan-roaster-scope";
    repo = "artisan";
    tag = "v${version}";
    sha256 = "sha256-JQUDW8RXQSTt0XE9MJ2lZ5/jvFcy0op+dEpMjNNmK2I=";
  };

  dontWrapGApps = true;
  dontWrapQtApps = true;

  nativeBuildInputs = [
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    pythonEnv
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwebengine
    qt6.qtwayland
    libusb1
    libphidget22
    libphidget22extra
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "artisan";
      exec = "artisan %U";
      icon = "artisan";
      desktopName = "Artisan";
      comment = "Visual scope for coffee roasters";
      categories = [ "Utility" ];
      mimeTypes = [
        "application/x-artisan-alog"
        "application/x-artisan-alrm"
        "application/x-artisan-apal"
        "application/x-artisan-aset"
        "application/x-artisan-wg"
        "application/x-artisan-athm"
      ];
      terminal = false;
      tryExec = "artisan";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/{artisan,pixmaps}

    # Copy artisan source
    cp -r src/* $out/share/artisan/

    # Copy icons
    cp $out/share/artisan/artisan.png $out/share/pixmaps/

    # Create wrapper script
    makeWrapper ${pythonEnv.interpreter} $out/bin/artisan \
      --add-flags "$out/share/artisan/artisan.py" \
      --set PYTHONPATH "$PYTHONPATH:$out/share/artisan" \
      --set QT_QPA_PLATFORM xcb \
      --prefix PATH : ${lib.makeBinPath [ libusb1 ]} \
      ''${gappsWrapperArgs[@]} \
      ''${qtWrapperArgs[@]}

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=v([\\d.]+)" ];
  };

  meta = {
    description = "Visual scope for coffee roasters";
    homepage = "https://artisan-scope.org/";
    changelog = "https://github.com/artisan-roaster-scope/artisan/releases/tag/v${version}";
    downloadPage = "https://github.com/artisan-roaster-scope/artisan/releases";
    license = lib.licenses.gpl3Only;
    mainProgram = "artisan";
    maintainers = with lib.maintainers; [ bohreromir ];
    platforms = [ "x86_64-linux" ];
  };
}
