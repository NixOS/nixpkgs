{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixf,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixf-diagnose";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "inclyc";
    repo = "nixf-diagnose";
    rev = "594f61cfb3d97adb2829eadd829de05aed5b49b7";
    hash = "sha256-6pKnGPEvnB7w9F+y2/pQb96s1MLQprStgBdeLpk2xWE=";
  };

  env.NIXF_TIDY_PATH = lib.getExe nixf;

  cargoHash = "sha256-LutCktLHpfl5aMvN9RW0IL9nojcq4j2kjc9zfeePCMg=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI wrapper for nixf-tidy with fancy diagnostic output";
    mainProgram = "nixf-diagnose";
    homepage = "https://github.com/inclyc/nixf-diagnose";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ inclyc ];
  };
})
