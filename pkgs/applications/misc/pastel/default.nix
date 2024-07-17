{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "pastel";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sharkdp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-uK4HWC+uGiey+K0p8+Wi+Pi+U7b4k09b8iKF9BmTPcc=";
  };

  cargoSha256 = "sha256-5paHSrqU8tItD/CAbauj6KcW/mKsveOAfXjD/NUuFAc=";

  buildInputs = lib.optional stdenv.isDarwin Security;

  meta = with lib; {
    description = "A command-line tool to generate, analyze, convert and manipulate colors";
    homepage = "https://github.com/sharkdp/pastel";
    changelog = "https://github.com/sharkdp/pastel/releases/tag/v${version}";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ davidtwco ];
    mainProgram = "pastel";
  };
}
