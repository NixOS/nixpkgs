{
  lib,
  stdenv,
  rustPlatform,
  bun,
  codex,
  dbus,
  desktop-file-utils,
  fetchFromGitHub,
  cargo-tauri,
  jq,
  makeWrapper,
  moreutils,
  nodejs_22,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  writableTmpDirAsHomeHook,
  wrapGAppsHook3,

  version ? "0.26.0",
  srcHash ? "sha256-4JlTGBDCeEyeVxATHFxkQyJrjfCrkyA/b9mVGDbbtKA=",
  source ? fetchFromGitHub {
    owner = "milisp";
    repo = "codexia";
    tag = "v${version}";
    hash = srcHash;
  },
  cargoHash ? "sha256-zHT5iWqvd2V0GWepehneDmGYnfl7XvIA3FHuxy1zIRs=",
  nodeModulesHash ? "sha256-8Uo4XufXRlbHxZcbzhyfgqAxZ65jXSLFN/3D8ZpIyTU=",
  nodejs ? nodejs_22,
}:

let
  commonMeta = {
    homepage = "https://github.com/milisp/codexia";
    changelog = "https://github.com/milisp/codexia/releases/tag/v${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ lostmsu ];
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
  };

  src = source;

  # Downstreams can point to a fork or local checkout by overriding `source`.
  # The dependency hashes only need to be overridden when the lockfiles change.
  node_modules = stdenv.mkDerivation {
    pname = "codexia-node_modules";
    inherit src version;

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;
    dontPatchShebangs = true;

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      bun install \
        --cpu="*" \
        --frozen-lockfile \
        --ignore-scripts \
        --no-progress \
        --os="*"

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      cp -R ./node_modules $out

      runHook postInstall
    '';

    outputHash = nodeModulesHash;
    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
  };

  commonArgs = {
    inherit src version cargoHash;

    cargoRoot = "src-tauri";
    buildAndTestSubdir = "src-tauri";
    strictDeps = true;
    doCheck = false;

    postPatch = ''
      substituteInPlace src-tauri/Cargo.toml \
        --replace-fail 'features = ["macos-private-api", "protocol-asset", "devtools"]' \
                       'features = ["macos-private-api", "protocol-asset"]'

      jq '
        .app.windows |= map(.devtools = false) |
        .plugins.updater.endpoints = [] |
        .bundle.createUpdaterArtifacts = false |
        .bundle.macOS.signingIdentity = null
      ' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
    '';

    configurePhase = ''
      runHook preConfigure

      cp -R ${node_modules} node_modules
      chmod -R u+rw node_modules
      chmod -R u+x node_modules/.bin
      patchShebangs node_modules

      export HOME=$TMPDIR
      export PATH="$PWD/node_modules/.bin:$PATH"

      runHook postConfigure
    '';
  };

in
{
  codexia = rustPlatform.buildRustPackage (
    finalAttrs:
    commonArgs
    // {
      pname = "codexia";

      nativeBuildInputs = [
        bun
        cargo-tauri.hook
        jq
        makeWrapper
        moreutils
        nodejs
        pkg-config
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ];

      buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
        dbus
        openssl
        webkitgtk_4_1
      ];

      preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
        gappsWrapperArgs+=(
          --prefix PATH : "${lib.makeBinPath [ desktop-file-utils ]}"
        )
      '';

      tauriBuildFlags = [ "--no-sign" ];

      postInstall =
        lib.optionalString stdenv.hostPlatform.isDarwin ''
          mkdir -p $out/bin
          makeWrapper $out/Applications/codexia.app/Contents/MacOS/codexia $out/bin/codexia
        ''
        + ''
          mkdir -p $out/dist
          cp -r dist/. $out/dist/
        '';

      meta = commonMeta // {
        description = "Desktop workspace and headless server for Codex CLI and Claude Code";
        mainProgram = "codexia";
        platforms = cargo-tauri.hook.meta.platforms;
      };
    }
  );

  codexia-web = rustPlatform.buildRustPackage (
    finalAttrs:
    commonArgs
    // {
      pname = "codexia-web";

      buildNoDefaultFeatures = true;
      buildFeatures = [ "web" ];

      nativeBuildInputs = [
        bun
        jq
        makeWrapper
        moreutils
        nodejs
        pkg-config
      ];

      buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
        dbus
        openssl
      ];

      preBuild = ''
        bun run build
      '';

      postInstall = ''
        mkdir -p $out/dist
        cp -r dist/. $out/dist/
        mv $out/bin/codexia $out/bin/codexia-web
      '';

      postFixup = ''
        wrapProgram $out/bin/codexia-web \
          --prefix PATH : "${lib.makeBinPath [ codex ]}"
      '';

      meta = commonMeta // {
        description = "Headless Codexia web server for Codex CLI and Claude Code";
        mainProgram = "codexia-web";
        platforms = lib.platforms.linux ++ lib.platforms.darwin;
      };
    }
  );
}
