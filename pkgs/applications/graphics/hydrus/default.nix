{ lib
, fetchFromGitHub
, wrapQtAppsHook
, miniupnpc
, ffmpeg
, enableSwftools ? false
, swftools
, python3Packages
, pythonOlder
, qtbase
, qtcharts
, makeDesktopItem
, copyDesktopItems
}:

python3Packages.buildPythonPackage rec {
  pname = "hydrus";
  version = "598";
  format = "other";

  src = fetchFromGitHub {
    owner = "hydrusnetwork";
    repo = "hydrus";
    rev = "refs/tags/v${version}";
    hash = "sha256-i9XeZJgB0oDimoc0D5UTYSBs9C55QXC6HIxv2gP8vWY=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    python3Packages.mkdocs-material
    copyDesktopItems
  ];

  buildInputs = [
    qtbase
    qtcharts
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
      categories = [ "FileTools" "Utility" ];
    })
  ];


  propagatedBuildInputs = with python3Packages; [
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

  nativeCheckInputs = with python3Packages; [
    mock
    httmock
  ];

  outputs = [ "out" "doc" ];

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
  '' + lib.optionalString enableSwftools ''
    mkdir -p $out/${python3Packages.python.sitePackages}/bin
    # swfrender seems to have to be called sfwrender_linux
    # not sure if it can be loaded through PATH, but this is simpler
    # $out/python3Packages.python.sitePackages/bin is correct NOT .../hydrus/bin
    ln -s ${swftools}/bin/swfrender $out/${python3Packages.python.sitePackages}/bin/swfrender_linux
  '' + ''
    runHook postInstall
  '';

  checkPhase = ''
    runHook preCheck

    export QT_QPA_PLATFORM=offscreen
    export HOME=$(mktemp -d)
    $out/bin/hydrus-test

    runHook postCheck
  '';

  dontWrapQtApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix PATH : ${lib.makeBinPath [ ffmpeg miniupnpc ]})
  '';

  meta = with lib; {
    description = "Danbooru-like image tagging and searching system for the desktop";
    license = licenses.wtfpl;
    homepage = "https://hydrusnetwork.github.io/hydrus/";
    maintainers = with maintainers; [ dandellion evanjs ];
  };
}
