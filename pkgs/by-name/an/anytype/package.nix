{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  pkg-config,
  anytype-heart,
  libsecret,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? "",
}:

let
  pname = "anytype";
  version = "0.47.5";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-ts";
    tag = "v${version}";
    hash = "sha256-u4LgnXaNPMohcu/vw5agzUHh4pRWnruAGZo++J0q/Ww=";
  };
  description = "P2P note-taking tool";

  locales = fetchFromGitHub {
    owner = "anyproto";
    repo = "l10n-anytype-ts";
    rev = "bd68ab3ffb0216dc3de845222b76efaf03745fd2";
    hash = "sha256-BRPjvcGJmLBl5P3KUXG7Ol9S9AKV7o/9eLemX8GDrB8=";
  };
in
buildNpmPackage {
  inherit pname version src;

  npmDepsHash = "sha256-1Tig1ItirOUE2TC/Pw6cGkgMnEWoqQ2kdDJEqtYgBUU=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [ libsecret ];

  npmFlags = [
    # keytar needs to be built against electron's ABI
    "--nodedir=${electron.headers}"
  ];

  patches = [
    ./0001-feat-update-Disable-auto-checking-for-updates-and-updating-manually.patch
    ./0002-remove-grpc-devtools.patch
  ];

  buildPhase = ''
    runHook preBuild

    cp -r ${anytype-heart}/lib dist/
    cp -r ${anytype-heart}/bin/anytypeHelper dist/

    for lang in ${locales}/locales/*; do
      cp "$lang" "dist/lib/json/lang/$(basename $lang)"
    done

    npm run build

    runHook postBuild
  '';

  # remove unnecessary files
  preInstall = ''
    npm prune --omit=dev
    chmod u+w -R dist
    find -type f \( -name "*.ts" -o -name "*.map" \) -exec rm -rf {} +
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/anytype
    cp -r electron.js electron dist node_modules package.json $out/lib/anytype/

    for icon in $out/lib/anytype/electron/img/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/anytype.png"
    done

    cp LICENSE.md $out/share

    makeWrapper '${lib.getExe electron}' $out/bin/anytype \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags $out/lib/anytype/ \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "anytype";
      exec = "anytype %U";
      icon = "anytype";
      desktopName = "Anytype";
      comment = description;
      mimeTypes = [ "x-scheme-handler/anytype" ];
      categories = [
        "Utility"
        "Office"
        "Calendar"
        "ProjectManagement"
      ];
      startupWMClass = "anytype";
    })
  ];

  meta = {
    inherit description;
    homepage = "https://anytype.io/";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "anytype";
    maintainers = with lib.maintainers; [
      autrimpo
      adda
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
