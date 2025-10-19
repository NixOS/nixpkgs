{
  stdenv,
  lib,
  fetchFromGitHub,
  gradle_9,
  jdk25,
  fetchurl,
  unzip,
  wrapGAppsHook3,
  libXxf86vm,
  libXtst,
  libglvnd,
  glib,
  alsa-lib,
  ffmpeg,
  lsb-release,
  copyDesktopItems,
  makeDesktopItem,
  writeScript,
}:
let
  gradle = gradle_9;
in
stdenv.mkDerivation rec {
  pname = "ed-odyssey-materials-helper";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "jixxed";
    repo = "ed-odyssey-materials-helper";
    tag = version;
    hash = "sha256-TcRj+TZ4shY1UAE7TseRXZZJZtL8aaD79pBL9LeoMJA=";
  };

  upstreamBuild = fetchurl {
    url = "https://github.com/jixxed/ed-odyssey-materials-helper/releases/download/${version}/Elite.Dangerous.Odyssey.Materials.Helper-${version}.portable.linux.zip";
    hash = "sha256-qjhQlZXg+u1YIshv1Skh4XWMjILBWE+N7vPVum7fHIg=";
  };

  nativeBuildInputs = [
    gradle
    wrapGAppsHook3
    copyDesktopItems
    unzip
  ];

  patches = [
    # We'll set up the edomh: URL scheme in makeDesktopItem,
    # so this removes 1) the popup about it when you first start the program, 2) the option in the settings
    # and makes the program always know that it is set up
    ./remove-urlscheme-settings.patch
  ];
  postPatch = ''
    # oslib doesn't seem to do releases and hasn't had a change since 2021, so always use commit d6ee6549bb
    # it is not the latest commit because using a commit here whose hash starts with a number causes issues, but this works
    substituteInPlace build.gradle \
      --replace-fail '"com.github.wille:oslib:master-SNAPSHOT"' '"com.github.wille:oslib:d6ee6549bb"'
    substituteInPlace application/src/main/java/module-info.java \
      --replace-fail 'requires oslib.master.SNAPSHOT;' 'requires oslib.d6ee6549bb;'

    # remove "new version available" popup
    substituteInPlace application/src/main/java/nl/jixxed/eliteodysseymaterials/FXApplication.java \
      --replace-fail 'versionPopup();' ""

    # telemetry doesn't work anyway, remove the option in the settings
    substituteInPlace application/src/main/java/nl/jixxed/eliteodysseymaterials/templates/settings/sections/Tracking.java \
      --replace-fail "trackingOptOutSetting, " ""

    for f in build.gradle */build.gradle; do
      substituteInPlace $f \
        --replace-fail 'vendor = JvmVendorSpec.AZUL' ""
    done
  '';

  mitmCache = gradle.fetchDeps {
    inherit pname;
    data = ./deps.json;
  };

  gradleFlags = [
    "-Dorg.gradle.java.home=${jdk25}"
    "--stacktrace"
  ];

  gradleBuildTask = "application:jpackage";

  preBuild = ''
    # We're going to extract some details from the upstream build which are not in the source.
    # Note that there are more build secrets, but they're for telemetry, so we're not extracting those.
    unzip -j $upstreamBuild lib/runtime/lib/modules

    function testVar {
      # if the variable was found and set, print it and continue, else abort the built
      if test -n "''${!1}"; then
        echo $1=''${!1}
      else
        echo $1" not set! (something has changed which requires the package definition to be updated)"
        false
      fi
    }

    export EDDN_SOFTWARE_NAME=`grep -a eddn.software.name= modules | cut -d= -f2`
    testVar EDDN_SOFTWARE_NAME

    export BROKER_HOST=`grep -a broker.host= modules | cut -d= -f2`
    testVar BROKER_HOST

    export CCID=`grep -a ccid= modules | cut -d= -f2`
    testVar CCID

    export MARKET_SERVICES_HOST=`grep -a market.services.host= modules | cut -d= -f2`
    testVar MARKET_SERVICES_HOST

    # due to this actually being a binary file this doesn't end with a newline and has other data after, we'll just assume it ends with .nl
    export COMMODITY_HOST=`grep -a commodity.host= modules | cut -d= -f2 | sed 's/\.nl.*/.nl/'`
    testVar COMMODITY_HOST

    # Use the env variables we just set
    gradle $gradleFlags application:generateSecrets
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{share/ed-odyssey-materials-helper,bin}
    cp -r application/build/jpackage/Elite\ Dangerous\ Odyssey\ Materials\ Helper/* $out/share/ed-odyssey-materials-helper

    mkdir -p $out/share/icons/hicolor/512x512/apps/
    ln -s $out/share/ed-odyssey-materials-helper/lib/Elite\ Dangerous\ Odyssey\ Materials\ Helper.png $out/share/icons/hicolor/512x512/apps/ed-odyssey-materials-helper.png

    runHook postInstall
  '';

  dontWrapGApps = true;

  postFixup = ''
    makeWrapper $out/share/ed-odyssey-materials-helper/bin/Elite\ Dangerous\ Odyssey\ Materials\ Helper $out/bin/ed-odyssey-materials-helper \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libXxf86vm
          glib
          libXtst
          libglvnd
          alsa-lib
          ffmpeg
        ]
      } \
      --prefix PATH : ${lib.makeBinPath [ lsb-release ]} \
      "''${gappsWrapperArgs[@]}"
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "ed-odyssey-materials-helper";
      type = "Application";
      desktopName = "Elite Dangerous Odyssey Materials Helper";
      comment = "Helper for managing materials in Elite Dangerous Odyssey";
      icon = "ed-odyssey-materials-helper";
      exec = "ed-odyssey-materials-helper %u";
      categories = [ "Game" ];
      mimeTypes = [ "x-scheme-handler/edomh" ];
    })
  ];

  gradleUpdateScript = ''
    runHook preBuild

    gradle application:nixDownloadDeps -Dos.family=linux -Dos.arch=amd64
    gradle application:nixDownloadDeps -Dos.family=linux -Dos.arch=aarch64
  '';

  passthru.updateScript = writeScript "update-ed-odyssey-materials-helper" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p nix-update

    nix-update ed-odyssey-materials-helper # update version and hash

    # update hash of upstreamBuild
    oldHash=`nix-instantiate --eval --raw -A ed-odyssey-materials-helper.upstreamBuild.outputHash`
    newHash=`nix-hash --type sha256 --to-sri $(nix-prefetch-url $(nix-instantiate --eval --raw -A ed-odyssey-materials-helper.upstreamBuild.url))`
    sed -i "s|$oldHash|$newHash|" pkgs/by-name/ed/ed-odyssey-materials-helper/package.nix

    `nix-build --no-out-link -A ed-odyssey-materials-helper.mitmCache.updateScript` # update deps.json
  '';

  meta = {
    description = "Helper for managing materials in Elite Dangerous Odyssey";
    homepage = "https://github.com/jixxed/ed-odyssey-materials-helper";
    downloadPage = "https://github.com/jixxed/ed-odyssey-materials-helper/releases/tag/${version}";
    changelog = "https://github.com/jixxed/ed-odyssey-materials-helper/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
    maintainers = with lib.maintainers; [
      elfenermarcell
      toasteruwu
    ];
    mainProgram = "ed-odyssey-materials-helper";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  };
}
