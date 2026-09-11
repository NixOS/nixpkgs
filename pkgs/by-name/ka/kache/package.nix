{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
  stdenv,
  pkg-config,
  sqlite,
  zstd,
  versionCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "kache";
  version = "2.1.1";
  __structuredAttrs = true;

  outputs = [ "out" ] ++ lib.optional stdenv.hostPlatform.isUnix "shims";

  src = fetchFromGitHub {
    owner = "kunobi-ninja";
    repo = "kache";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5461iJuvDpibacLGgx7dzA6Dix5UleDnqklgmfQ5p8w=";
  };

  cargoHash = "sha256-6aGg58ikEDwCZjmtV0H9MySs0UDWMYdHE/qEZO2U0JE=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    sqlite
    zstd
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  cargoBuildFlags = [
    "-p"
    "kache"
  ];

  # The upstream suite is expensive to compile and has filesystem-sensitive failures on Hydra:
  # - cli::tests::target_rows_report_each_worktree_and_sort_by_what_frees_most
  #   reports equal reclaimable sizes for different-sized fixtures on ZFS.
  # - target_cleanup::tests::pressure_recovery_waits_for_a_build_lock_then_removes_an_idle_target
  #   assumes a 64 KiB fixture has at least 64 KiB of reclaimable space.
  doCheck = false;
  doInstallCheck = true;

  postInstall = lib.optionalString stdenv.hostPlatform.isUnix ''
    mkdir -p "$shims/bin"
    for name in cc c++ gcc g++ clang clang++ cargo rustdoc; do
      ln -s "$out/bin/kache" "$shims/bin/$name"
    done
    # Let another kache on PATH recognize and skip this shim directory.
    touch "$shims/bin/.kache-shims"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Zero-copy, content-addressed build cache for Rust, C/C++ and more";
    homepage = "https://github.com/kunobi-ninja/kache";
    license = lib.licenses.asl20;
    mainProgram = "kache";
    maintainers = with lib.maintainers; [ stefanboca ];
  };
})
