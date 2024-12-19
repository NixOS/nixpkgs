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

  cargoHash = "sha256-sQ6f8BHGsPFPchFDjNlZimnu9i99SGYf5bYfM1/2Gac=";

  meta = with lib; {
    description = "CLI to pretty print logs in bunyan format (Rust port of the original JavaScript bunyan CLI)";
    homepage = "https://github.com/LukeMathWalker/bunyan";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ netcrns ];
    mainProgram = "bunyan";
  };
}
