{
  rustPlatform,
  fetchFromGitHub,
  lib,
}:

rustPlatform.buildRustPackage rec {
  pname = "bunyan-rs";
  version = "0.1.9";

  src = fetchFromGitHub {
    owner = "LukeMathWalker";
    repo = "bunyan";
    rev = "v${version}";
    sha256 = "sha256-dqhZIwxWBMXS2RgE8YynYrESVyAOIJ9ujAKcp2tDhvA=";
  };

  cargoHash = "sha256-eLbfrlZWwPv1AFgwFz+IacLZrSl9/KU9zfTstwB8ol0=";

<<<<<<< HEAD
  meta = {
    description = "CLI to pretty print logs in bunyan format (Rust port of the original JavaScript bunyan CLI)";
    homepage = "https://github.com/LukeMathWalker/bunyan";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ netcrns ];
=======
  meta = with lib; {
    description = "CLI to pretty print logs in bunyan format (Rust port of the original JavaScript bunyan CLI)";
    homepage = "https://github.com/LukeMathWalker/bunyan";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ netcrns ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "bunyan";
  };
}
