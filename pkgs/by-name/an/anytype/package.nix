{
  lib,
  callPackage,
  fetchFromGitHub,
  buildNpmPackage,
  pkg-config,
  libsecret,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? "",
  nix-update-script,
}:

let
  anytype-heart = callPackage ./anytype-heart { };
  pname = "anytype";
  version = "0.45.3";

  src = fetchFromGitHub {
    owner = "anyproto";
    repo = "anytype-ts";
    tag = "v${version}";
    hash = "sha256-fwfxmNca75xAAHKeT2nddz+XZexDomzHbw188LXxZqA=";
  };
  description = "P2P note-taking tool";

  locales = fetchFromGitHub {
    owner = "anyproto";
    repo = "l10n-anytype-ts";
    rev = "687106c4e37297f86fab79f77ef83599b61ab65c";
    hash = "sha256-Y0irD0jzqYobnjtD2M1+hTDRUUYnuygUx9+tE1gUoTw=";
  };
in
buildNpmPackage {
  inherit pname version src;

  npmDepsHash = "sha256-9BI+rXzTYonlMhcH8uiWyyF18JGv8GL1U9hZ9Z6X3As=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  nativeBuildInputs = [
    pkg-config
    copyDesktopItems
  ];
  buildInputs = [ libsecret ];

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

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/anytype
    cp -r electron.js electron dist node_modules package.json $out/lib/node_modules/anytype/

    for icon in $out/lib/node_modules/anytype/electron/img/icons/*.png; do
      mkdir -p "$out/share/icons/hicolor/$(basename $icon .png)/apps"
      ln -s "$icon" "$out/share/icons/hicolor/$(basename $icon .png)/apps/anytype.png"
    done

    cp LICENSE.md $out/share

    makeWrapper '${lib.getExe electron}' $out/bin/anytype \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags $out/lib/node_modules/anytype/ \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "Anytype";
      exec = "anytype";
      icon = "anytype";
      desktopName = "Anytype";
      comment = description;
      categories = [
        "Utility"
        "Office"
        "Calendar"
        "ProjectManagement"
      ];
      startupWMClass = "anytype";
    })
  ];

  passthru.updateScript = nix-update-script {
    # Prevent updating to versions with '-' in them.
    # Necessary since Anytype uses Electron-based 'MAJOR.MINOR.PATCH(-{alpha,beta})?' versioning scheme where each
    #  {alpha,beta} version increases the PATCH version, releasing a new full release version in GitHub instead of a
    #  pre-release version.
    extraArgs = [
      "--version-regex"
      "[^-]*"
    ];
  };

  meta = {
    inherit description;
    homepage = "https://anytype.io/";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "anytype";
    maintainers = with lib.maintainers; [
      running-grass
      autrimpo
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}
