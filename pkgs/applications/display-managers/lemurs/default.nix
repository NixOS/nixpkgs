{
  fetchFromGitHub,
  lib,
  linux-pam,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "lemurs";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "coastalwhite";
    repo = "lemurs";
    rev = "v${version}";
    hash = "sha256-6mNSLEWafw8yDGnemOhEiK8FTrBC+6+PuhlbOXTGmN0=";
  };

  cargoHash = "sha256-nfUBC1HSs7PcIbD7MViJFkfFAPda83XbAupNeShfwOs=";

  # Fixes a lock issue
  preConfigure = "cargo update --offline";

  buildInputs = [
    linux-pam
  ];

  meta = with lib; {
    description = "A customizable TUI display/login manager written in Rust";
    homepage = "https://github.com/coastalwhite/lemurs";
    license = with licenses; [asl20 mit];
    maintainers = with maintainers; [jeremiahs];
  };
}
