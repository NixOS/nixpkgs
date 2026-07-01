{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitLab,
  fetchpatch,
  pkg-config,
  sqlite,
  openssl,
  versionCheckHook,
  nix-update-script,
  nixosTests,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "arti";
  version = "2.4.0";

  src = fetchFromGitLab {
    domain = "gitlab.torproject.org";
    group = "tpo";
    owner = "core";
    repo = "arti";
    tag = "arti-v${finalAttrs.version}";
    hash = "sha256-YLOdrHstmN2pLl75uclkbpN5h3iBs3xpraZ8XN6R/+Q=";
  };

  patches = [
    # Fixes a panic that could allow malicious directory caches to crash
    # clients.
    # https://gitlab.torproject.org/tpo/core/arti/-/merge_requests/4062
    (fetchpatch {
      name = "TROVE-2026-024.patch";
      url = "https://gitlab.torproject.org/tpo/core/arti/-/commit/f69be8c70561629e63004788f0aa4bf898025f93.patch";
      hash = "sha256-P0sXTKOBW7ulqQZwmTVJfrpLksLyaonuDpxGF2keDqE=";
    })
  ];

  # Working around a bug in cargo that appears with cargo-auditable, see
  # https://github.com/rust-secure-code/cargo-auditable/issues/124.
  postPatch = ''
    substituteInPlace crates/arti/Cargo.toml \
      --replace-fail '"tor-rpcbase"' '"dep:tor-rpcbase"'
  '';

  buildAndTestSubdir = "crates/arti";
  cargoHash = "sha256-7X3JJbt0/jxaMvBR3XQvguR7tqd96kiqX66G2byvPjM=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ pkg-config ];

  buildInputs = [ sqlite ] ++ lib.optionals stdenv.hostPlatform.isLinux [ openssl ];
  # `full` includes all stable and non-conflicting feature flags. the primary
  # downsides are increased binary size and memory usage for building, but
  # those are acceptable for nixpkgs
  buildFeatures = [ "full" ];

  # several tests under `full` require access to internal types, which are
  # currently marked as experimental for public usage.
  checkFeatures = [
    "full"
    "experimental-api"
  ];

  checkFlags = [
    # problematic test that hangs the build
    "--skip=reload_cfg::test::watch_single_file"
  ];

  # some of the CLI tests attempt to validate that the filesystem and runtime
  # environment are securely configured, which breaks inside the nix build
  # sandbox. this does NOT affect downstream users of Arti.
  env.ARTI_FS_DISABLE_PERMISSION_CHECKS = 1;

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    tests = { inherit (nixosTests) tor; };
    updateScript = nix-update-script { extraArgs = [ "--version-regex=^arti-v(.*)$" ]; };
  };

  meta = {
    description = "Implementation of Tor in Rust";
    mainProgram = "arti";
    homepage = "https://arti.torproject.org/";
    changelog = "https://gitlab.torproject.org/tpo/core/arti/-/blob/arti-v${finalAttrs.version}/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      rapiteanu
      whispersofthedawn
    ];
  };
})
