{
  lib,
  pkgsStatic,
  fetchFromGitHub,
  aws-lc,
  pkg-config,
}:

pkgsStatic.rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rcp";
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "wykurz";
    repo = "rcp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3vpIPj376RKrgFKAKE0Y4bhHrc3/UNlth4xq2OnziBg=";
  };

  cargoHash = "sha256-OtaxWhT9X4stYY/hDYd632YHoQwX2B4FpqYufmlAK3M=";

  # Enable upstream's Nix sandbox test filter without replacing nixpkgs'
  # target-specific Rust flags. Keep this config identical in both phases so
  # Cargo can reuse the release artifacts built before the checks.
  cargoBuildFlags = [
    "--config"
    ''target.'cfg(all())'.rustflags=["--cfg","tokio_unstable","--cfg","rcp_nix_sandbox"]''
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  # fixtures that mutate process-global admission, congestion, hook and file-descriptor
  # state are only supported under nextest's process isolation or single-threaded libtest
  dontUseCargoParallelTests = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
  ];

  meta = {
    changelog = "https://github.com/wykurz/rcp/releases/tag/v${finalAttrs.version}";
    description = "Tools to efficiently copy, remove and link large filesets";
    homepage = "https://github.com/wykurz/rcp";
    license = lib.licenses.mit;
    mainProgram = "rcp";
    maintainers = with lib.maintainers; [ wykurz ];
    # procfs only supports Linux and Android
    broken = pkgsStatic.stdenv.hostPlatform.isDarwin;
  };
})
