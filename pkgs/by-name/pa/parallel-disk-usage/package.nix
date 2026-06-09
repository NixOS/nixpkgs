{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "parallel-disk-usage";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    rev = finalAttrs.version;
    hash = "sha256-EYveK1p/OWvtY5Q0dDlZwFkVt7u/A0qY0BG/oLgwmfE=";
  };

  cargoHash = "sha256-r9lNOElOr4GjzaI1ZZFdc+1i2kC4YVl7n/XR05mdEJA=";

  meta = {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.peret ];
    mainProgram = "pdu";
  };
})
