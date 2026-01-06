{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  fetchzip,
  makeBinaryWrapper,

  makeDesktopItem,
  copyDesktopItems,
  replaceVars,

  todds,

  steam,
}:
let
  pname = "rimsort";
  version = "1.0.47";

  src = fetchFromGitHub {
    owner = "RimSort";
    repo = "RimSort";
    rev = "v${version}";
    hash = "sha256-1wn3WIflrhH3IMBeGFwcHi0zOREakuk/5gqwPY720eA=";
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

stdenv.mkDerivation {
  inherit pname;
  inherit version;

  unpackPhase = ''
    runHook preUnpack

    cp -r ${src} source
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
  ];

  buildInputs = [
    todds
    steamfiles
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
    pytestCheckHook
    pytest-cov-stub
    pytest-qt
    pytest-xvfb
  ];

  doCheck = true;

  preCheck = ''
    export QT_DEBUG_PLUGINS=1
    export QT_QPA_PLATFORM=offscreen
    export HOME=$(mktemp -d) # Some tests require a writable directory
  '';

  disabledTestPaths = [
    # requires network
    "tests/models/metadata/test_metadata_factory.py"
  ];

  pytestFlags = [ "--doctest-modules" ];

  desktopItems = [
    (makeDesktopItem {
      name = "RimSort";
      desktopName = "RimSort";
      exec = "rimsort";
      icon = "rimsort";
      comment = "RimWorld Mod Manager";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/rimsort
    cp -r ./* $out/lib/rimsort/

    mkdir -p $out/bin

    makeBinaryWrapper \
      ${python3Packages.python.interpreter} \
      $out/bin/rimsort \
      --add-flags "-m app" \
      --chdir $out/lib/rimsort \
      --prefix PYTHONPATH : "$PYTHONPATH" \
      --set RIMSORT_DISABLE_UPDATER 1

    install -D ./themes/default-icons/AppIcon_a.png $out/share/icons/hicolor/512x512/apps/rimsort.png

    runHook postInstall
  '';

  meta = {
    description = "Open source mod manager for the video game RimWorld";
    homepage = "https://github.com/RimSort/RimSort";
    license = with lib.licenses; [
      gpl3Only
      # For libsteam_api.so
      (
        unfreeRedistributable
        // {
          url = "https://partner.steamgames.com/documentation/sdk_access_agreement";
        }
      )
    ];
    maintainers = with lib.maintainers; [ weirdrock ];
    mainProgram = "rimsort";
    # steamworksSrc is x86_64-linux only
    platforms = [ "x86_64-linux" ];
  };
}
