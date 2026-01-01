{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  wrapGAppsHook4,
  nix-update-script,

  cargo-tauri,
  nodejs,
  pkg-config,
<<<<<<< HEAD
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,

  alsa-lib,
=======
  pnpm,

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  glib-networking,
  libappindicator-gtk3,
  openssl,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin-desktop";
<<<<<<< HEAD
  # TODO When updating the version, check if the version-mismatch workaround in preBuild is still needed
  version = "0.2.11";
=======
  version = "0.2.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-tVIT3GUJ1qcv6HSvO+nqAz+VMfd8g9AjgaqE6+GSa+I=";
  };

  cargoRoot = "./.";
  cargoHash = "sha256-T3cPvwph71lpqlGcugAO4Ua8Y5TNZSySbQatxcvoT4E=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-XqKGAx2Q9cWO1oG4mP1cKM2Y9Pib5haFYEaq0PAfAdQ=";
=======
    hash = "sha256-jBCf6Wq7xTgI2VjhQ+RZ3uN7LVh+ZlQ3TDJ0epsGj0M=";
  };

  cargoRoot = "./.";
  cargoHash = "sha256-329uNcc8LSNreD8CgPCpEhGCR2PebpmFoaRwZn+oscE=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-2i1mL4HwwiXrmM1qaWvHhm27U2/oElbOpnXh09ziamo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [
    cargo-tauri.hook
<<<<<<< HEAD
    pnpmConfigHook
    pnpm
    rustPlatform.bindgenHook
=======
    pnpm.configHook
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
<<<<<<< HEAD
    alsa-lib
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    glib-networking
    libappindicator-gtk3
    openssl
    webkitgtk_4_1
  ];

  env = {
    # Used upstream: https://github.com/atuinsh/desktop/blob/6ddebdf66c70042defe5587f7f6c433f889b9ef4/.envrc#L1
    NODE_OPTIONS = "--max-old-space-size=6144";
  };

  # Otherwise tauri will look for a private key we don't have.
  tauriConf = builtins.toJSON { bundle.createUpdaterArtifacts = false; };
  passAsFile = [ "tauriConf" ];
  preBuild = ''
    npm rebuild ts-tiny-activerecord
    tauriBuildFlags+=(
      "--config"
      "$tauriConfPath"
<<<<<<< HEAD
      # Skips the version mismatch check (and accepts the consequences)
      # ref: https://github.com/atuinsh/desktop/issues/313
      "--ignore-version-mismatches"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    )
  '';

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    "--skip=ui::viewport::tests::test_add_line_scrolling"
    "--skip=ui::viewport::tests::test_line_wrapping"
  ];
  doCheck = !stdenv.isDarwin;

  meta = {
    description = "Local-first, executable runbook editor";
    homepage = "https://atuin.sh";
    downloadPage = "https://github.com/atuinsh/desktop";
    changelog = "https://github.com/atuinsh/desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adda
      dzervas
      randoneering
    ];
    mainProgram = "atuin-desktop";
    platforms = with lib.platforms; windows ++ darwin ++ linux;
  };
})
