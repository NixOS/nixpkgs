{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "proximity-sort";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jonhoo";
    repo = "proximity-sort";
    rev = "v${version}";
    hash = "sha256-MRLQvspv6kjirljhAkk1KT+hPA4hdjA1b7RL9eEyglQ=";
  };

  cargoHash = "sha256-rlxNvIYtVdWth5ZEdbmxOf3GKXIBpHnGDcSO883Ldjg=";

<<<<<<< HEAD
  meta = {
    description = "Simple command-line utility for sorting inputs by proximity to a path argument";
    homepage = "https://github.com/jonhoo/proximity-sort";
    license = with lib.licenses; [
=======
  meta = with lib; {
    description = "Simple command-line utility for sorting inputs by proximity to a path argument";
    homepage = "https://github.com/jonhoo/proximity-sort";
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      mit # or
      asl20
    ];
    maintainers = [ ];
    mainProgram = "proximity-sort";
  };
}
