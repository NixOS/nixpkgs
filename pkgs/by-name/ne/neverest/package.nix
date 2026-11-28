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

  pname = "neverest";
  version = "1.0.0";
  cargoHash = "sha256-cXSC+Av4YjyFGztUsbDzpMLxB1j/7iIud2+tc2Boduo=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "neverest";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h5cISmgzlFOE7YfxVCMBpCZEdPbMZmkQlWCa0q2qHfA=";
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

  buildInputs = [
    sqlite'
  ]
  ++ lib.optional nativeTls openssl
  ++ lib.optional rustlsAws aws-lc;

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/neverest"
        else
          lib.getExe buildPackages.neverest;
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      install -Dm644 config.sample.toml "$out"/share/doc/neverest/config.sample.toml
      ${exe} manual -d "$out"/share/man
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} json-schema -d "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd neverest \
        --bash "$out"/share/completions/neverest.bash \
        --fish "$out"/share/completions/neverest.fish \
        --zsh "$out"/share/completions/_neverest
    '';

  # disable impure integration tests: they open sockets against live servers
  cargoTestFlags = [ "--bins" ];

  # some unit tests require network, should be fixed for next release
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI to synchronize mails, contacts and calendars";
    mainProgram = "neverest";
    homepage = "https://github.com/pimalaya/neverest";
    changelog = "https://github.com/pimalaya/neverest/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ soywod ];
  };
})
