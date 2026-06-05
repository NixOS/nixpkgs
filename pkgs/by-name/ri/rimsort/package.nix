{
  lib,
  stdenv,
  python3Packages,
  qt6,
  fetchFromGitHub,
  fetchzip,
  makeBinaryWrapper,
  nix-update-script,

  makeDesktopItem,
  copyDesktopItems,
  replaceVars,

  todds,
  steam,
}:
let
  pname = "rimsort";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "RimSort";
    repo = "RimSort";
    tag = "v${version}";
    hash = "sha256-1yUzRqOrrSBe5ulUiNiJGdF/fg1wCT/0Y6baWZ+VUjc=";
    fetchSubmodules = true;
  };

  steamworksSrc = fetchzip {
    url = "https://web.archive.org/web/20250527013243/https://partner.steamgames.com/downloads/steamworks_sdk_162.zip"; # Steam sometimes requires auth to download.
    hash = "sha256-yDA92nGj3AKTNI4vnoLaa+7mDqupQv0E4YKRRUWqyZw=";
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
    cp ${steamworksSrc}/redistributable_bin/linux64/libsteam_api.so source/

    runHook postUnpack
  '';

  sourceRoot = "source";

  patches = [
    (replaceVars ./todds-path.patch { inherit todds; })
    (replaceVars ./steam-run.patch { inherit steam-run; })
  ];

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
      steamworkspy
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

  disabledTests = [
    # Works with hard-coded executable paths.
    "test_execute_calls_runner_when_binary_exists"
    "test_execute_shows_error_when_binary_missing"
    "test_download_mods_sets_console_log_path"
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
      # For libsteam_api.so
      valveSDK
    ];
    maintainers = with lib.maintainers; [
      adda
      weirdrock
    ];
    mainProgram = "rimsort";
    # steamworksSrc is x86_64-linux only
    platforms = [ "x86_64-linux" ];
  };
})
