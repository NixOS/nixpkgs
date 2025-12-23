{
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  versionCheckHook,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    rev = "1d576dc75ca066879f6d9ee4d156c5bce940bd31";
    hash = "sha256-rqR4A7JpIgdTxjIvq4KNmvU3LMLUZS1AaLSQWVk+tdw=";
  };

  cargoHash = "sha256-FHzFxDnpQL0XSyTAfANsK60y8aOFQMkF4KZFdaspYEI=";

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  buildInputs = [
    openssl
  ];

  cargoBuildFlags = [ "-p spacetimedb-standalone -p spacetimedb-cli" ];

  preCheck = ''
    # server tests require home dir
    export HOME=$(mktemp -d)
  '';

  checkFlags = [
    # require wasm32-unknown-unknown target
    "--skip=codegen"
    "--skip=publish"
  ];

  doInstallCheck = true;

  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
    # used by crates/cli/build.rs to set GIT_HASH at compile time
    SPACETIMEDB_NIX_BUILD_GIT_COMMIT = finalAttrs.src.rev;
    # required to make jemalloc_tikv_sys build
    CFLAGS = "-O";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/spacetime";
  versionCheckProgramArg = "--version";

  postInstall = ''
    mv $out/bin/spacetimedb-cli $out/bin/spacetime
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Full-featured relational database system that lets you run your application logic inside the database";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
