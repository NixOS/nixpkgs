{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  qt6,
  copyDesktopItems,
  makeDesktopItem,
  writableTmpDirAsHomeHook,
  ffmpeg,
  miniupnpc,
}:

python3Packages.buildPythonApplication rec {
  pname = "hydrus";
  version = "653";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "hydrusnetwork";
    repo = "hydrus";
    tag = "v${version}";
    hash = "sha256-OH07OvN5EaEsjlUHUJMqproiVcN75yL9u7lnCjXSITo=";
  };

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    python3Packages.mkdocs-material
    copyDesktopItems
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtcharts
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "hydrus-client";
      exec = "hydrus-client";
      desktopName = "Hydrus Client";
      icon = "hydrus-client";
      comment = meta.description;
      terminal = false;
      type = "Application";
      categories = [
        "FileTools"
        "Utility"
      ];
    })
  ];

  dependencies =
    with python3Packages;
    [
      beautifulsoup4
      cbor2
      chardet
      dateparser
      html5lib
      lxml
      lz4
      mpv
      numpy
      opencv4
      olefile
      pillow
      pillow-heif
      pillow-jpegxl-plugin
      psutil
      pympler
      pyopenssl
      pyqt6
      pyqt6-charts
      pysocks
      python-dateutil
      pyyaml
      qtpy
      requests
      show-in-file-manager
      send2trash
      service-identity
      twisted
    ]
    ++ python3Packages.twisted.optional-dependencies.tls
    ++ python3Packages.twisted.optional-dependencies.http2;

  nativeCheckInputs =
    (with python3Packages; [
      mock
      httmock
    ])
    ++ [
      writableTmpDirAsHomeHook
    ];

  outputs = [
    "out"
    "doc"
  ];

  installPhase = ''
    runHook preInstall

    # Move the hydrus module and related directories
    mkdir -p $out/${python3Packages.python.sitePackages}
    mv {hydrus,static,db} $out/${python3Packages.python.sitePackages}
    # Fix random files being marked with execute permissions
    chmod -x $out/${python3Packages.python.sitePackages}/static/*.{png,svg,ico}
    # Build docs
    mkdocs build -d help
    mkdir -p $doc/share/doc
    mv help $doc/share/doc/hydrus

    # install the hydrus binaries
    mkdir -p $out/bin
    install -m0755 hydrus_server.py $out/bin/hydrus-server
    install -m0755 hydrus_client.py $out/bin/hydrus-client
    install -m0755 hydrus_test.py $out/bin/hydrus-test

    # desktop item
    mkdir -p "$out/share/icons/hicolor/scalable/apps"
    ln -s "$doc/share/doc/hydrus/assets/hydrus-white.svg" "$out/share/icons/hicolor/scalable/apps/hydrus-client.svg"

    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM=offscreen
    $out/bin/hydrus-test

    runHook postCheck
  '';

  # Tests crash even with __darwinAllowLocalNetworking enabled
  # hydrus.core.HydrusExceptions.DataMissing: That service was not found!
  doCheck = !stdenv.hostPlatform.isDarwin;

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
        miniupnpc
      ]
    })
  '';

  meta = {
    description = "Danbooru-like image tagging and searching system for the desktop";
    mainProgram = "hydrus-client";
    license = lib.licenses.wtfpl;
    homepage = "https://hydrusnetwork.github.io/hydrus/";
    changelog = "https://github.com/hydrusnetwork/hydrus/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [
      dandellion
      evanjs
      KunyaKud
    ];
  };
}
