{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  qt6,
  copyDesktopItems,
  makeDesktopItem,
  writableTmpDirAsHomeHook,
  swftools,
  ffmpeg,
  miniupnpc,

  enableSwftools ? false,
}:

python3Packages.buildPythonApplication rec {
  pname = "hydrus";
  version = "631";
  format = "other";

  src = fetchFromGitHub {
    owner = "hydrusnetwork";
    repo = "hydrus";
    tag = "v${version}";
    hash = "sha256-YZnlQIiq0dUGEnQgVCTvNS+kuSpXlaAN5UvZAQ3xeZM=";
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

  dependencies = with python3Packages; [
    beautifulsoup4
    cbor2
    chardet
    cloudscraper
    dateparser
    html5lib
    lxml
    lz4
    numpy
    opencv4
    olefile
    pillow
    pillow-heif
    psutil
    psd-tools
    pympler
    pyopenssl
    pyqt6
    pyqt6-charts
    pysocks
    python-dateutil
    python3Packages.mpv
    pyyaml
    qtpy
    requests
    show-in-file-manager
    send2trash
    service-identity
    twisted
  ];

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
  ''
  + lib.optionalString enableSwftools ''
    mkdir -p $out/${python3Packages.python.sitePackages}/bin
    # swfrender seems to have to be called sfwrender_linux
    # not sure if it can be loaded through PATH, but this is simpler
    # $out/python3Packages.python.sitePackages/bin is correct NOT .../hydrus/bin
    ln -s ${swftools}/bin/swfrender $out/${python3Packages.python.sitePackages}/bin/swfrender_linux
  ''
  + ''
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
    license = lib.licenses.wtfpl;
    homepage = "https://hydrusnetwork.github.io/hydrus/";
    changelog = "https://github.com/hydrusnetwork/hydrus/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [
      dandellion
      evanjs
    ];
  };
}
