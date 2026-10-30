{
  lib,
  stdenv,
  python3Packages,
  qt6,
  fetchFromGitHub,
  makeBinaryWrapper,
  nix-update-script,

  makeDesktopItem,
  copyDesktopItems,

  todds,
  steam,
}:
let
  pname = "rimsort";
  version = "1.17.4";

  src = fetchFromGitHub {
    owner = "RimSort";
    repo = "RimSort";
    tag = "v${version}";
    hash = "sha256-gxHY4DRfrjx4Wc/nIU6H+ifs8vNdyhsQG0hX2y2lZFo=";
    fetchSubmodules = true;
  };

  steamfiles = python3Packages.buildPythonPackage {
    pname = "steamfiles";
    inherit version;
    format = "setuptools";

    src = "${src}/submodules/steamfiles";
    dependencies = with python3Packages; [
      protobuf
      protobuf3-to-dict
    ];
  };

  steam-run =
    (steam.override {
      privateTmp = false;
    }).run;
in

stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;

  inherit pname;
  inherit version;
  inherit src;

  unpackPhase = ''
    runHook preUnpack

    cp -r ${finalAttrs.src} source
    chmod -R 755 source

    runHook postUnpack
  '';

  sourceRoot = "source";

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    todds
    steamfiles
    qt6.qtbase
    qt6.qtwayland
  ]
  ++ builtins.attrValues {
    inherit (python3Packages)
      beautifulsoup4
      certifi
      chardet
      imageio
      loguru
      lxml
      msgspec
      natsort
      networkx
      packaging
      platformdirs
      psutil
      pygit2
      pygithub
      pyperclip
      pyside6
      requests
      sqlalchemy
      steam
      toposort
      watchdog
      xmltodict
      zstandard
      steamworks
      ;
  };

  dontBuild = true;

  nativeCheckInputs = with python3Packages; [
    aiohttp
    pytest-asyncio
    pytestCheckHook
    pytest-cov-stub
    pytest-mock
    pytest-qt
    pytest-xvfb
    rapidfuzz
  ];

  doCheck = true;

  preCheck = ''
    export QT_DEBUG_PLUGINS=1
    export QT_QPA_PLATFORM=offscreen
    export HOME=$(mktemp -d) # Some tests require a writable directory
  '';

  disabledTestPaths = [
    # Requires network access (clones GitHub: Community-Rules-Database, Steam-Workshop-Database)
    "tests/models/metadata/test_metadata_factory.py"
    # Requires network access.
    "tests/utils/test_privatebin.py"
  ];

  pytestFlags = [ "--doctest-modules" ];

  desktopItems = [
    (makeDesktopItem {
      name = "io.github.rimsort.RimSort";
      desktopName = "RimSort";
      exec = "rimsort";
      icon = "rimsort";
      comment = "RimWorld Mod Manager";
      categories = [ "Game" ];
      startupWMClass = "io.github.rimsort.RimSort";
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/rimsort
    cp -r ./* $out/lib/rimsort/

    mkdir -p $out/bin

    # AppInfo reads the displayed version from version.xml
    # (the release workflow writes it for the other builds)
    cat > $out/lib/rimsort/version.xml <<EOF
    <version>
      <version>${version}</version>
    </version>
    EOF

    install -D ./themes/default-icons/AppIcon_a.png $out/share/icons/hicolor/512x512/apps/rimsort.png

    runHook postInstall
  '';

  postFixup = ''
    makeBinaryWrapper \
      ${python3Packages.python.interpreter} \
      $out/bin/rimsort \
      --add-flags "-m app" \
      --chdir $out/lib/rimsort \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set RIMSORT_DISABLE_UPDATER 1 \
      --set RIMSORT_LAUNCH_PREFIX ${steam-run}/bin/steam-run \
      --set RIMSORT_TODDS_PATH ${todds}/bin/todds \
      "''${qtWrapperArgs[@]}"
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [
      # To skip checking the pre-release 'Edge' release as 'vEdge'.
      "--version-regex"
      "v([0-9.]+)"
    ];
  };

  meta = {
    description = "Open source mod manager for the video game RimWorld";
    homepage = "https://github.com/RimSort/RimSort";
    license = with lib.licenses; [
      gpl3Only
      # For vendored libs/libsteam_api.so
      valveSDK
    ];
    maintainers = with lib.maintainers; [
      adda
      twstagg
    ];
    mainProgram = "rimsort";
    platforms = [ "x86_64-linux" ];
  };
})
