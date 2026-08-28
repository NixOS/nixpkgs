{
  lib,
  fetchFromGitHub,
  flutter347,
  makeDesktopItem,
  copyDesktopItems,
  git,
  powershell,
  alsa-lib,
  mpv-unwrapped,
  libplacebo,
  libappindicator,
  webkitgtk_4_1,
}:

let
  flutter = flutter347;
  srcInfo = lib.importJSON ./src-info.json;
  description = "Third-party Bilibili client developed in Flutter";
  version = "2.1.2.1";
in
flutter347.buildFlutterApplication {
  pname = "piliplus";
  inherit version;

  src = fetchFromGitHub {
    owner = "bggRGjQaUbCoE";
    repo = "PiliPlus";
    inherit (srcInfo) rev hash;
  };

  patches = [
    ./disable-auto-update.patch

    # lib/scripts/patch.ps1 normally deletes material_ui
    # and runs `flutter pub get` to restore it.
    # in nix we provide a writable pub cache ourselves
    ./no-remove-before-patch.patch
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git-hashes.json;

  nativeBuildInputs = [
    git # used extensively in lib/scripts/patch.ps1
    powershell
    copyDesktopItems
  ];

  buildInputs = [
    alsa-lib
    mpv-unwrapped
    libplacebo
    libappindicator
    webkitgtk_4_1
  ];

  preBuild = ''
    # see lib/scripts/build.ps1
    cat <<JSON > pili_release.json
    {
      "pili.hash": "${srcInfo.rev}",
      "pili.name": "${version}",
      "pili.code": ${toString srcInfo.revCount},
      "pili.time": ${toString srcInfo.commitDate}
    }
    JSON

    export FLUTTER_ROOT="$PWD/.flutter-sdk"
    cp -aL '${flutter.sdk}' "$FLUTTER_ROOT"
    chmod -R u+w "$FLUTTER_ROOT"
    git -C "$FLUTTER_ROOT" reset --hard HEAD

    export PUB_CACHE="$PWD/.pub-cache"
    mkdir -p "$PUB_CACHE/hosted/pub.dev"

    # build a writable pub cache with the packages that patch.ps1 patches
    buildWritablePubCache() {
      packageDir="$(jq --arg packageName "$1" -r '
        .packages[]
        | select(.name == $packageName)
        | .rootUri
        | ltrimstr("file://")
        | rtrimstr("/.")
      ' .dart_tool/package_config.json)"
      cacheDir="$PUB_CACHE/hosted/pub.dev/$(basename "$packageDir" | sed 's/^[^-]*-pub-//')"
      cp -a "$packageDir" "$cacheDir"
      chmod -R u+w "$cacheDir"
      echo "$cacheDir"
    }
    materialUiCacheDir="$(buildWritablePubCache material_ui)"
    buildWritablePubCache cupertino_ui > /dev/null

    HOME="$PWD" GITHUB_WORKSPACE="$PWD" pwsh lib/scripts/patch.ps1 Linux

    # point package resolution at the patched Flutter SDK and material_ui.
    jq --arg flutterRoot "file://$FLUTTER_ROOT" --arg materialRoot "file://$materialUiCacheDir/." '
      .packages |= map(
        if (.rootUri | contains("flutter-sdk-")) then
          if .name == "sky_engine" then .rootUri = "\($flutterRoot)/bin/cache/pkg/sky_engine/."
          else .rootUri = "\($flutterRoot)/packages/\(.name)/."
          end
        elif .name == "material_ui" then .rootUri = $materialRoot
        else .
        end
      )
    ' .dart_tool/package_config.json > .dart_tool/package_config.json.tmp
    mv .dart_tool/package_config.json.tmp .dart_tool/package_config.json
  '';

  flutterBuildFlags = [ "--dart-define-from-file=pili_release.json" ];

  postInstall = ''
    declare -A sizes=(
      [mdpi]=128
      [hdpi]=192
      [xhdpi]=256
      [xxhdpi]=384
      [xxxhdpi]=512
    )
    for var in "''${!sizes[@]}"; do
      width=''${sizes[$var]}
      install -Dm644 "android/app/src/main/res/drawable-$var/splash.png" \
        "$out/share/icons/hicolor/''${width}x$width/apps/piliplus.png"
    done
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "piliplus";
      exec = "piliplus";
      icon = "piliplus";
      desktopName = "PiliPlus";
      categories = [
        "Video"
        "AudioVideo"
      ];
      comment = description;
    })
  ];

  passthru.updateScript = ./update.rb;

  meta = {
    inherit description;
    homepage = "https://github.com/bggRGjQaUbCoE/PiliPlus";
    changelog = "https://github.com/bggRGjQaUbCoE/PiliPlus/releases/tag/${version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ulysseszhan ];
    platforms = lib.platforms.linux;
    mainProgram = "piliplus";
  };
}
