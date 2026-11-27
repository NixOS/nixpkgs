{
  aws-lc,
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  fetchFromGitHub,
  installManPages ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  installShellFiles,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  sqlite,
  stdenv,
  windows,
}:

let
  nativeTls = builtins.elem "native-tls" buildFeatures;
  rustlsAws = builtins.elem "rustls-aws" buildFeatures;
  pimdir = !buildNoDefaultFeatures || builtins.elem "pimdir" buildFeatures;

  # nixpkgs' mingw sqlite fails its pthread probe and compiles
  # single-threaded, defining no sqlite3_mutex_* rusqlite links against
  sqlite' =
    if stdenv.hostPlatform.isWindows then
      sqlite.overrideAttrs (old: {
        buildInputs = (old.buildInputs or [ ]) ++ [ windows.pthreads ];
      })
    else
      sqlite;

in
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;

  inherit buildFeatures buildNoDefaultFeatures;

  pname = "himalaya";
  version = "3.0.0";
  cargoHash = "sha256-uMdU0l5A/BYPNyJt1Oh2MH+0xTxwwpZ9W6u/mH8a+Zk=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "himalaya";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cFWCnXgFFQ8ciyhGhJXRKaOvCRBDtuUMBjZSsgLAQio=";
  };

  # openssl should not be provided by vendors, not even on windows
  env.OPENSSL_NO_VENDOR = 1;

  # pkg-config hands the linker libsqlite3 but no rpath, leaving a binary that
  # cannot find it: not in postInstall, which runs it, nor once installed.
  env.NIX_LDFLAGS = "-rpath " + lib.getLib sqlite' + "/lib";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    lib.optional pimdir sqlite' ++ lib.optional nativeTls openssl ++ lib.optional rustlsAws aws-lc;

  # the tests' dev-dependencies link sqlite, whatever the features
  checkInputs = [ sqlite' ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/himalaya"
        else
          lib.getExe buildPackages.himalaya;
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      install -Dm644 config.sample.toml "$out"/share/doc/himalaya/config.sample.toml
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} manual -d "$out"/share/man
      ${exe} json-schema -d "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd himalaya \
        --bash "$out"/share/completions/himalaya.bash \
        --fish "$out"/share/completions/himalaya.fish \
        --zsh "$out"/share/completions/_himalaya
    '';

  # disable impure integration tests: they bind sockets and spawn processes
  cargoTestFlags = [
    "--bins"
    "--lib"
  ];

  # some unit tests require network, should be fixed for next release
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI to manage emails";
    mainProgram = "himalaya";
    homepage = "https://github.com/pimalaya/himalaya";
    changelog = "https://github.com/pimalaya/himalaya/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      soywod
      yanganto
    ];
  };
})
