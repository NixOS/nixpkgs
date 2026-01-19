{
  lib,
  stdenv,
  fetchFromGitHub,
  buildNpmPackage,
  nodejs_22,
  pkg-config,
  anytype-heart,
  libsecret,
  electron,
  go,
  lsof,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? "",
}:

buildNpmPackage (finalAttrs: {
  pname = "anytype";
  version = "0.53.1";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-ts";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GDx40UA+Grc/xvlfwqtN1WNonm9c0dci1rereWpfhjs=";
  };

  locales = fetchFromGitHub {
    owner = "anyproto";
    repo = "l10n-anytype-ts";
    rev = "f9dc9286757c2544fe801a1e31067cbe708cc6f1";
    hash = "sha256-/rZCpeKGtPttYbuJbhbOV4P1sXSvIYve0WO/SL20isw=";
  };

  npmDepsHash = "sha256-hJJK/RJnSm8QpjGcnxUsemrAsRNYCHSGSH8iUZZYXJI=";

  # npm dependency install fails with nodejs_24: https://github.com/NixOS/nixpkgs/issues/474535
  nodejs = nodejs_22;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  nativeBuildInputs = [
    pkg-config
    go
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

    for lang in ${finalAttrs.locales}/locales/*; do
      cp "$lang" "dist/lib/json/lang/$(basename $lang)"
    done

    npm run build
    npm run build:nmh

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

    wrapProgram $out/lib/anytype/dist/nativeMessagingHost \
       --prefix PATH : ${lib.makeBinPath [ lsof ]}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "anytype";
      exec = "anytype %U";
      icon = "anytype";
      desktopName = "Anytype";
      comment = finalAttrs.meta.description;
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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "P2P note-taking tool";
    homepage = "https://anytype.io/";
    changelog = "https://community.anytype.io/t/anytype-desktop-${
      builtins.replaceStrings [ "." ] [ "-" ] (lib.versions.majorMinor finalAttrs.version)
    }-0-released";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "anytype";
    maintainers = with lib.maintainers; [
      autrimpo
      adda
      kira-bruneau
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})
