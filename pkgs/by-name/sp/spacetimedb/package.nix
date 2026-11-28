{
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  perl,
  openssl,
  zstd,
  rust-jemalloc-sys,
  libgit2,
  versionCheckHook,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  nix-update-script,
  writableTmpDirAsHomeHook,
  coreutils,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "spacetimedb";
  version = "2.15.0";

  src = fetchFromGitHub {
    owner = "clockworklabs";
    repo = "spacetimedb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-C007eKzhLcVoLoYvPBzmFe42bKsDhBX8+OaQiwpQRpY=";
  };

  cargoPatches = [
    ./update-git2.patch
  ];

  cargoHash = "sha256-XUjTuLsbwf8p6xgtYruVzR1rzx+pFbjYVyutgpazuwA=";

  postPatch = ''
    substituteInPlace crates/cli/src/schema_extract/tests.rs \
      --replace-fail /bin/cat ${coreutils}/bin/cat \
      --replace-fail /usr/bin/head ${coreutils}/bin/head
  '';

  nativeBuildInputs = [
    pkg-config
    perl
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
    zstd
    rust-jemalloc-sys
    libgit2
  ];

  cargoBuildFlags = [ "-p spacetimedb-standalone -p spacetimedb-cli" ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  __darwinAllowLocalNetworking = true;

  checkFlags = [
    # require wasm32-unknown-unknown target
    "--skip=codegen"
    "--skip=publish"
  ];

  # system-configuration needs configd: "Attempted to create a NULL object."
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.SystemConfiguration.configd"))
  '';

  doInstallCheck = true;

  env = {
    RUSTY_V8_ARCHIVE = librusty_v8;
    # used by crates/cli/build.rs to set GIT_HASH at compile time
    SPACETIMEDB_NIX_BUILD_GIT_COMMIT = finalAttrs.src.rev;
    RUSTFLAGS = "--cfg tokio_unstable";
  };

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = "${placeholder "out"}/bin/spacetime";

  postInstall = ''
    mv $out/bin/spacetimedb-cli $out/bin/spacetime
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    description = "Full-featured relational database system that lets you run your application logic inside the database";
    homepage = "https://github.com/clockworklabs/SpacetimeDB";
    license = lib.licenses.bsl11;
    mainProgram = "spacetime";
    maintainers = with lib.maintainers; [ akotro ];
  };
})
