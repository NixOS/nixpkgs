{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  fetchzip,
  makeWrapper,

  makeDesktopItem,
  replaceVars,

  todds,

  steam,
}:
let
  pname = "rimsort";
  version = "1.0.20";

  srcs = [
    (fetchFromGitHub {
      owner = "RimSort";
      repo = "RimSort";
      tag = "v${version}";
      hash = "sha256-ISor56g3zj7ktSmgh+JS0IbSmgrj6Dv4mTPa18F1UgI=";
      fetchSubmodules = true;
    })
    (fetchzip {
      url = "https://web.archive.org/web/20250527013243/https://partner.steamgames.com/downloads/steamworks_sdk_162.zip"; # Steam sometimes requires auth to download.
      hash = "sha256-yDA92nGj3AKTNI4vnoLaa+7mDqupQv0E4YKRRUWqyZw=";
    })
  ];

  steamfiles = python3Packages.buildPythonPackage {
    pname = "steamfiles";
    inherit version;
    src = "${builtins.elemAt srcs 0}/submodules/steamfiles";
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

    cp -r ${builtins.elemAt srcs 0} source
    chmod -R 755 source
    cp ${builtins.elemAt srcs 1}/redistributable_bin/linux64/libsteam_api.so source/

    runHook postUnpack
  '';

  sourceRoot = "source";

  patches = [
    (replaceVars ./todds-path.patch { inherit todds; })
    (replaceVars ./steam-run.patch { inherit steam-run; })
    ./hide-update-check-dialog.patch
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs =
    [
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
        steamworkspy
        ;
    };

  dontBuild = true;

  desktopItems = [
    (makeDesktopItem {
      name = "RimSort";
      desktopName = "RimSort";
      exec = "rimsort";
      icon = "io.github.rimsort.rimsort";
      comment = "RimWorld Mod Manager";
      categories = [ "Game" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/usr/lib/rimsort
    cp -r ./* $out/usr/lib/rimsort/

    mkdir -p $out/bin

    makeWrapper \
      ${python3Packages.python.interpreter} \
      $out/bin/rimsort \
      --add-flags "-m app" \
      --chdir $out/usr/lib/rimsort \
      --prefix PYTHONPATH : "$PYTHONPATH"

    install -D ./themes/default-icons/AppIcon_a.png $out/share/icons/hicolor/512x512/apps/io.github.rimsort.rimsort

    runHook postInstall
  '';

  meta = {
    description = "Open source mod manager for the video game RimWorld";
    homepage = "https://github.com/RimSort/RimSort";
    license = with lib.licenses; [
      gpl3Only
      (
        unfreeRedistributable
        // {
          url = "https://partner.steamgames.com/documentation/sdk_access_agreement";
        }
      )
    ];
    maintainers = with lib.maintainers; [ weirdrock ];
    mainProgram = "todds";
    platforms = lib.platforms.linux;
  };
}
