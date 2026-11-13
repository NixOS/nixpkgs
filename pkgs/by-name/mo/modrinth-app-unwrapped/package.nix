{
  lib,
  stdenv,
  cacert,
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  gradle_9,
  jdk17,
  makeBinaryWrapper,
  makeShellWrapper,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  replaceVars,
  runCommand,
  rustPlatform,
  sqlite,
  turbo,
  webkitgtk_4_1,
  xcbuild,
  zstd,
}:

let
  gradle = gradle_9.override { java = jdk; };
  jdk = jdk17;
  pnpm = pnpm_12;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "modrinth-app-unwrapped";
  version = "0.23.5";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W+shEjcObasPfDho9ylhxyM6N21Hl5uFO8W7PORqHlo=";
  };

  patches = [
    # `packages/app-lib/build.rs` requires a Gradle executable, but our flags
    # are injected through a bash function sourced by the stdenv :(
    #
    # So, re-implement said wrapper to have the same behavior when Gradle is ran in `build.rs`
    (replaceVars ./gradle-from-path.patch {
      # Yes, it has to be a shell wrapper
      # https://github.com/NixOS/nixpkgs/issues/172583
      gradle =
        runCommand "gradle-exe-wrapper-${gradle.version}" { nativeBuildInputs = [ makeShellWrapper ]; }
          ''
            makeShellWrapper ${lib.getExe gradle} $out \
              --add-flags "\''${NIX_GRADLEFLAGS_COMPILE:-}"
          '';
    })

    # `gradle.fetchDeps` doesn't seem to pick up a few integrations here
    # Thankfully that's fine, since it's only for development
    ./remove-spotless.patch
  ];

  postPatch = ''
    # Let the app know about our actual version number
    substituteInPlace {apps/app,packages/app-lib}/Cargo.toml apps/app-frontend/package.json \
      --replace-fail '1.0.0-local' '${finalAttrs.version}'

    # Ignore running pnpm version not matching the declared version.
    # Pnpm will try to to download the correct version otherwise.
    # See: https://pnpm.io/settings/cli#pmonfail
    echo 'pmOnFail: warn' >> pnpm-workspace.yaml
  '';

  cargoHash = "sha256-s1NlmC7R4KQoJGDnc7mxbPOSqraMkQrwpNyKH07Vsiw=";

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  pnpmDeps = fetchPnpmDeps {
    inherit pnpm;
    inherit (finalAttrs) pname version src;
    fetcherVersion = 5;
    hash = "sha256-B9iUYcxEZp5iF9oA+3Vg6mHxfqCij1ZdKN8nLLJEsUw=";
  };

  nativeBuildInputs = [
    cacert # Required for turbo
    cargo-tauri.hook
    desktop-file-utils
    gradle
    nodejs
    pkg-config
    pnpm
    pnpmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    xcbuild
  ];

  buildInputs = [
    openssl
    sqlite
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux webkitgtk_4_1
  ++ lib.optional stdenv.hostPlatform.isDarwin zstd;

  gradleFlags = [
    "-Dfile.encoding=utf-8"
    "--no-configuration-cache"
  ];

  dontUseGradleBuild = true;
  dontUseGradleCheck = true;

  # Tests fail on other, unrelated packages in the monorepo
  cargoTestFlags = [
    "--package"
    "theseus_gui"
  ];

  # Required for mitmCache
  __darwinAllowLocalNetworking = true;

  env = {
    TURBO_BINARY_PATH = lib.getExe turbo;
    # Cidre requires a target version of at least 10.15
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-mmacosx-version-min=10.15";
  };

  preGradleUpdate = ''
    cd packages/app-lib/java
  '';

  # Required for the exe wrapper above
  preBuild = ''
    local nixGradleFlags=()
    concatTo nixGradleFlags gradleFlags gradleFlagsArray
    export NIX_GRADLEFLAGS_COMPILE="''${nixGradleFlags[@]}"

    cp packages/app-lib/.env.prod packages/app-lib/.env
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeBinaryWrapper "$out"/Applications/Modrinth\ App.app/Contents/MacOS/Modrinth\ App "$out"/bin/ModrinthApp
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "Modrinth's game launcher" \
        --set-key="StartupNotify" --set-value="true" \
        --set-key="Categories" --set-value="Game;ActionGame;AdventureGame;Simulation;" \
        --set-key="Keywords" --set-value="game;minecraft;mc;" \
        --set-key="StartupWMClass" --set-value="ModrinthApp" \
        $out/share/applications/Modrinth\ App.desktop
    '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modrinth's game launcher";
    longDescription = ''
      A unique, open source launcher that allows you to play your favorite mods,
      and keep them up to date, all in one neat little package
    '';
    homepage = "https://modrinth.com";
    license = with lib.licenses; [
      gpl3Plus
      unfreeRedistributable
    ];
    maintainers = with lib.maintainers; [
      getchoo
      hythera
      encode42
    ];
    mainProgram = "ModrinthApp";
    platforms = with lib.platforms; linux ++ darwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
