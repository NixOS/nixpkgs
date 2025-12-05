{
  lib,
  stdenv,
  cacert,
  cargo-tauri,
  desktop-file-utils,
  fetchFromGitHub,
  gradle_8,
  jdk11,
  makeBinaryWrapper,
  makeShellWrapper,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpm_9,
  replaceVars,
  runCommand,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
}:

let
  gradle = gradle_8.override { java = jdk; };
  jdk = jdk11;
  pnpm = pnpm_9;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "modrinth-app-unwrapped";
  version = "0.10.5";

  src = fetchFromGitHub {
    owner = "modrinth";
    repo = "code";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KqC+5RLLvg3cyjY7Ecw9qxQ5XUKsK7Tfxl4WC1OwZeI=";
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

  cargoHash = "sha256-chUPd1fLZ7dm0MXkbD7Bv4tE520ooEyliVZ9Pp+LIdk=";

  mitmCache = gradle.fetchDeps {
    inherit (finalAttrs) pname;
    data = ./deps.json;
  };

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 1;
    hash = "sha256-1tDegt8OgG0ZhvNGpkYQR+PuX/xI287OFk4MGAXUKZQ=";
  };

  nativeBuildInputs = [
    cacert # Required for turbo
    cargo-tauri.hook
    desktop-file-utils
    gradle
    nodejs
    pkg-config
    pnpm.configHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin makeBinaryWrapper;

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
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "ModrinthApp";
    platforms = with lib; platforms.linux ++ platforms.darwin;
    # This builds on architectures like aarch64, but the launcher itself does not support them yet.
    # Darwin is the only exception
    # See https://github.com/modrinth/code/issues/776#issuecomment-1742495678
    broken = !stdenv.hostPlatform.isx86_64 && !stdenv.hostPlatform.isDarwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # mitm cache
    ];
  };
})
