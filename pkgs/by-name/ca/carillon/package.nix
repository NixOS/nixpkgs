{
  aws-lc,
  buildFeatures ? [ ],
  buildNoDefaultFeatures ? false,
  buildPackages,
  dbus,
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
  notify = !buildNoDefaultFeatures || builtins.elem "notify" buildFeatures;
  vendored =
    stdenv.hostPlatform.isWindows || !buildNoDefaultFeatures || builtins.elem "vendored" buildFeatures;
  systemDbus = notify && !vendored;

  # dbus calls libgcc outline atomics that the static aarch64 link cannot
  # resolve (__aarch64_ldset4_sync & co), so inline them instead.
  dbus' =
    if stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64 then
      dbus.overrideAttrs (old: {
        env = (old.env or { }) // {
          NIX_CFLAGS_COMPILE = (old.env.NIX_CFLAGS_COMPILE or "") + " -mno-outline-atomics";
        };
      })
    else
      dbus;

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

  inherit buildNoDefaultFeatures;

  pname = "carillon";
  version = "1.0.0";
  cargoHash = "sha256-vBaGQRU8a6oVwBepY2KR3jFPa7nNI+uefc/M52dT3P0=";

  src = fetchFromGitHub {
    owner = "pimalaya";
    repo = "carillon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gYTJZunepbfEOgiMH5ovE95X19M2FIp6z3SBC7zDDcQ=";
  };

  env = {
    # pkg-config hands the linker libdbus and libsqlite3 but no rpath,
    # leaving a binary that cannot find them: not in postInstall, which runs
    # it, nor once installed.
    NIX_LDFLAGS = lib.concatStringsSep " " (
      lib.optional systemDbus ("-rpath " + lib.getLib dbus' + "/lib")
      ++ [ ("-rpath " + lib.getLib sqlite' + "/lib") ]
    );

    # openssl should not be provided by vendors, not even on windows
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs =
    lib.optional pimdir sqlite'
    ++ lib.optional nativeTls openssl
    ++ lib.optional rustlsAws aws-lc
    ++ lib.optional systemDbus dbus';

  buildFeatures =
    buildFeatures
    # dbus is provided by vendors on windows
    ++ lib.optional stdenv.hostPlatform.isWindows "vendored";

  # the tests' dev-dependencies link sqlite, whatever the features
  checkInputs = [ sqlite' ];

  postInstall =
    let
      exe =
        if stdenv.buildPlatform.canExecute stdenv.hostPlatform then
          "$out/bin/carillon"
        else
          lib.getExe buildPackages.carillon;
    in
    ''
      mkdir -p $out/share/{completions,man,schemas}
      install -Dm644 config.sample.toml "$out"/share/doc/carillon/config.sample.toml
      ${exe} completion -d "$out"/share/completions bash elvish fish powershell zsh
      ${exe} manual -d "$out"/share/man
      ${exe} json-schema -d "$out"/share/schemas
    ''
    + lib.optionalString installManPages ''
      installManPage "$out"/share/man/*
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p "$out"/lib/systemd/user
      substitute assets/carillon@.service "$out"/lib/systemd/user/carillon@.service \
        --replace-fail %install_dir% "$out"/bin
    ''
    + lib.optionalString installShellCompletions ''
      installShellCompletion --cmd carillon \
        --bash "$out"/share/completions/carillon.bash \
        --fish "$out"/share/completions/carillon.fish \
        --zsh "$out"/share/completions/_carillon
    '';

  # disable impure integration tests: they bind sockets and spawn processes
  cargoTestFlags = [ "--bins" ];

  # some unit tests require network, should be fixed for next release
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "CLI to watch PIM collection changes";
    mainProgram = "carillon";
    homepage = "https://github.com/pimalaya/carillon";
    changelog = "https://github.com/pimalaya/carillon/releases/tag/${finalAttrs.src.tag}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ soywod ];
  };
})
