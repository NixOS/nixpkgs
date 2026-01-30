{
  lib,
  stdenv,
  cacert,
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  gradle_8,
  jdk17,
  makeBinaryWrapper,
  makeShellWrapper,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  replaceVars,
  runCommand,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
  xcbuild,
}:

let
  gradle = gradle_8.override { java = jdk; };
  jdk = jdk17;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "modrinth-app-unwrapped";
  version = "0.10.27";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5KHxoOozqZMvq91oKZ18Hmt0W8r9Va0AJr0hWMmBCfs=";
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

  # Let the app know about our actual version number
  postPatch = ''
    substituteInPlace {apps/app,packages/app-lib}/Cargo.toml apps/app-frontend/package.json \
      --replace-fail '1.0.0-local' '${finalAttrs.version}'
  '';

  cargoHash = "sha256-OQVHG0iUyYcpc63N4Y3i8oWohDO4JBUIk3LEAf6ifL0=";
  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 1;
    hash = "sha256-N57RSuVRX33AhQBjHbxR0g9q62rYVqAlYJ1dhuUu0xw=";
  };

  nativeBuildInputs = [
    cacert # Required for turbo
    cargo-tauri.hook
    desktop-file-utils
    gradle
    nodejs
    pkg-config
    pnpmConfigHook
    pnpm_9
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    xcbuild
  ];

  buildInputs = [ openssl ] ++ lib.optional stdenv.hostPlatform.isLinux webkitgtk_4_1;

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
    # This builds on architectures like aarch64, but the launcher itself does not support them yet.
    # Darwin is the only exception
    # See https://github.com/modrinth/code/issues/776#issuecomment-1742495678
    broken = !stdenv.hostPlatform.isx86_64 || !stdenv.hostPlatform.isLinux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
