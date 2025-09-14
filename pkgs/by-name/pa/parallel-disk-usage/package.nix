{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "parallel-disk-usage";
  version = "0.21.1";

  src = fetchFromGitHub {
    owner = "KSXGitHub";
    repo = "parallel-disk-usage";
    rev = version;
    hash = "sha256-EYveK1p/OWvtY5Q0dDlZwFkVt7u/A0qY0BG/oLgwmfE=";
  };

  cargoHash = "sha256-r9lNOElOr4GjzaI1ZZFdc+1i2kC4YVl7n/XR05mdEJA=";

  meta = with lib; {
    description = "Highly parallelized, blazing fast directory tree analyzer";
    homepage = "https://github.com/KSXGitHub/parallel-disk-usage";
    license = licenses.asl20;
    maintainers = [ maintainers.peret ];
    mainProgram = "pdu";
  };
}
