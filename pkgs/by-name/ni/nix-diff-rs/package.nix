{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "nix-diff-rs";
  version = "0-unstable-2026-08-22";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "nix-diff-rs";
    rev = "bc31a21022671f257285f9443cc9d595a079efbc";
    hash = "sha256-3lOJ6E2HY865uhmDcCeM1pdtTFVq5vw/1erQrmjQ0cc=";
  };

  cargoHash = "sha256-DPHxOPBllnO6fyIRRElPo8WgZEWXL2Dq7qR4ePxiaH4=";

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeCheckInputs = [ nix ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version"
      "branch"
    ];
  };

  meta = {
    description = "Explain why two Nix derivations differ";
    homepage = "https://github.com/Mic92/nix-diff-rs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      me-and
      mic92
    ];
    mainProgram = "nix-diff";
  };
}
