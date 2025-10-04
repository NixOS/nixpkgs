{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  makeDesktopItem,
  yarn,
  nodejs,
  jq,
  electron_38,
  element-web,
  sqlcipher,
  callPackage,
  desktopToDarwinBundle,
  typescript,
  useKeytar ? true,
  # command line arguments which are always set
  commandLineArgs ? "",
}:

let
  pinData = import ./element-desktop-pin.nix;
  inherit (pinData.hashes) desktopSrcHash desktopYarnHash;
  executableName = "element-desktop";
  electron = electron_38;
  keytar = callPackage ./keytar {
    inherit electron;
  };
  seshat = callPackage ./seshat { };
in
stdenv.mkDerivation (
  finalAttrs:
  removeAttrs pinData [ "hashes" ]
  // {
    pname = "element-desktop";
    name = "${finalAttrs.pname}-${finalAttrs.version}";
    src = fetchFromGitHub {
      owner = "element-hq";
      repo = "element-desktop";
      rev = "v${finalAttrs.version}";
      hash = desktopSrcHash;
    };

    # TODO: fetchYarnDeps currently does not deal properly with a dependency
    # declared as a pin to a commit in a specific git repository.
    # While it does download everything correctly, `yarn install --offline`
    # always wants to `git ls-remote` to the repository, ignoring the local
    # cached tarball.
    offlineCache = callPackage ./yarn.nix {
      inherit (finalAttrs) version src;
      hash = desktopYarnHash;
    };

    nativeBuildInputs = [
      nodejs
      makeWrapper
      jq
      yarn
      typescript
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ desktopToDarwinBundle ];

    inherit seshat;

    # Only affects unused scripts in $out/share/element/electron/scripts. Also
    # breaks because there are some `node`-scripts with a `npx`-shebang and
    # this shouldn't be in the closure just for unused scripts.
    dontPatchShebangs = true;

    configurePhase = ''
      runHook preConfigure

      mkdir -p node_modules/
      cp -r $offlineCache/node_modules/* node_modules/
      substituteInPlace package.json --replace-fail "tsx " "node node_modules/tsx/dist/cli.mjs "

      runHook postConfigure
    '';

    # Workaround for darwin sandbox build failure: "Error: listen EPERM: operation not permitted ..tsx..."
    preBuild = lib.optionalString stdenv.hostPlatform.isDarwin ''
      export TMPDIR="$(mktemp -d)"
    '';

    buildPhase = ''
      runHook preBuild

      yarn --offline run build:ts
      node node_modules/matrix-web-i18n/scripts/gen-i18n.js
      yarn --offline run i18n:sort
      yarn --offline run build:res

      chmod -R a+w node_modules/keytar-forked
      rm -rf node_modules/matrix-seshat node_modules/keytar-forked
      ${lib.optionalString useKeytar "ln -s ${keytar} node_modules/keytar-forked"}
      ln -s $seshat node_modules/matrix-seshat

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      # resources
      mkdir -p "$out/share/element"
      ln -s '${element-web}' "$out/share/element/webapp"
      cp -r '.' "$out/share/element/electron"
      chmod -R "a+w" "$out/share/element/electron/node_modules"
      rm -rf "$out/share/element/electron/node_modules"
      cp -r './node_modules' "$out/share/element/electron"
      cp $out/share/element/electron/lib/i18n/strings/en_EN.json $out/share/element/electron/lib/i18n/strings/en-us.json
      ln -s $out/share/element/electron/lib/i18n/strings/en{-us,}.json

      # icon
      mkdir -p "$out/share/icons/hicolor/512x512/apps"
      ln -s "$out/share/element/electron/build/icon.png" "$out/share/icons/hicolor/512x512/apps/element.png"

      # desktop item
      mkdir -p "$out/share"
      ln -s "${finalAttrs.desktopItem}/share/applications" "$out/share/applications"

      # executable wrapper
      # LD_PRELOAD workaround for sqlcipher not found: https://github.com/matrix-org/seshat/issues/102
      makeWrapper '${electron}/bin/electron' "$out/bin/${executableName}" \
        --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher.so \
        --add-flags "$out/share/element/electron" \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
        --add-flags ${lib.escapeShellArg commandLineArgs}

      runHook postInstall
    '';

    # The desktop item properties should be kept in sync with data from upstream:
    # https://github.com/element-hq/element-desktop/blob/develop/package.json
    desktopItem = makeDesktopItem {
      name = "element-desktop";
      exec = "${executableName} %u";
      icon = "element";
      desktopName = "Element";
      genericName = "Matrix Client";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
        "InstantMessaging"
        "Chat"
      ];
      startupWMClass = "Element";
      mimeTypes = [
        "x-scheme-handler/element"
        "x-scheme-handler/io.element.desktop"
      ];
    };

    postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp build/icon.icns $out/Applications/Element.app/Contents/Resources/element.icns
    '';

    passthru = {
      # run with: nix-shell ./maintainers/scripts/update.nix --argstr package element-desktop
      updateScript = ./update.sh;

      # TL;DR: keytar is optional while seshat isn't.
      #
      # This prevents building keytar when `useKeytar` is set to `false`, because
      # if libsecret is unavailable (e.g. set to `null` or fails to build), then
      # this package wouldn't even considered for building because
      # "one of the dependencies failed to build",
      # although the dependency wouldn't even be used.
      #
      # It needs to be `passthru` anyways because other packages do depend on it.
      inherit keytar;
    };

    meta = with lib; {
      description = "Feature-rich client for Matrix.org";
      homepage = "https://element.io/";
      changelog = "https://github.com/element-hq/element-desktop/blob/v${finalAttrs.version}/CHANGELOG.md";
      license = licenses.asl20;
      teams = [ teams.matrix ];
      platforms = electron.meta.platforms ++ lib.platforms.darwin;
      mainProgram = "element-desktop";
    };
  }
)
