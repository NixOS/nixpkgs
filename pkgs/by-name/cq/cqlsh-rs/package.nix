{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  testers,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cqlsh-rs";
  version = "0.5.12";

  src = fetchFromGitHub {
    owner = "scylladb";
    repo = "cqlsh-rs";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0lxhO5mAcmF8lKzHUzUERjvvJVaPJ0VvZCu0ROPBRBY=";
  };

  # Upstream does not commit Cargo.lock.
  # See https://github.com/scylladb/cqlsh-rs/issues/172
  cargoLock = {
    lockFile = ./Cargo.lock;
  };

  postPatch = ''
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  env = lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Ensure deterministic Mach-O UUID on Darwin.
    SOURCE_DATE_EPOCH = 1;
  };

  preBuild = ''
    # Remap build directory paths for deterministic output.
    # Must be set in preBuild (not env) because $NIX_BUILD_TOP is a runtime
    # bash variable that cannot be expanded in Nix string literals, and
    # __structuredAttrs re-applies env vars between phases.
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
  '';

  # Only compile and run lib tests; skip integration tests and their heavy
  # dev-deps (testcontainers, criterion, etc.) which require Docker/network.
  cargoTestFlags = [ "--lib" ];

  # Pager tests use std::env::set_var("PAGER", ...) which is not thread-safe;
  # running tests serially avoids intermittent failures from env var races.
  dontUseCargoParallelTests = true;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installManPage --name cqlsh-rs.1 <($out/bin/cqlsh-rs --generate-man)

    installShellCompletion --cmd cqlsh-rs \
      --bash <($out/bin/cqlsh-rs --completions bash) \
      --fish <($out/bin/cqlsh-rs --completions fish) \
      --zsh <($out/bin/cqlsh-rs --completions zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Rust re-implementation of the Apache Cassandra cqlsh shell";
    homepage = "https://scylladb.github.io/cqlsh-rs/";
    changelog = "https://github.com/scylladb/cqlsh-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
    mainProgram = "cqlsh-rs";
  };
})
