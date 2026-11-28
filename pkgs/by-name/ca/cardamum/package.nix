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

  inherit buildNoDefaultFeatures buildFeatures;

  pname = "cardamum";
  version = "1.0.0";
  cargoHash = "sha256-19oaNxulVrW6HpdcTHh3YtBPz0FKDkrk3W99F5hWMjU=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "cardamum";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e3pDzIFJbx1dDCF3lQjhPJ1cp+7TxlXWZQdpsFE/XVI=";
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
          "$out/bin/cardamum"
        else
          lib.getExe buildPackages.cardamum;
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      install -Dm644 config.sample.toml "$out"/share/doc/cardamum/config.sample.toml
      ${exe} manual -d "$out"/share/man
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} json-schema -d "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd cardamum \
        --bash "$out"/share/completions/cardamum.bash \
        --fish "$out"/share/completions/cardamum.fish \
        --zsh "$out"/share/completions/_cardamum
    '';

  # disable impure integration tests: they bind sockets and spawn processes
  cargoTestFlags = [ "--bins" ];

  # some unit tests require network, should be fixed for next release
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI to manage contacts";
    mainProgram = "cardamum";
    homepage = "https://github.com/pimalaya/cardamum";
    changelog = "https://github.com/pimalaya/cardamum/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ soywod ];
  };
})
