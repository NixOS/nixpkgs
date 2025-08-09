{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "roon-tui";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "TheAppgineer";
    repo = "roon-tui";
    rev = version;
    hash = "sha256-ocPSqj9/xJ2metetn6OY+IEFWysbstPmh2N5Jd8NDPM=";
  };

  cargoHash = "sha256-+RIKnvMW56mbxLWvPFzT9IenTAFlQDhwrd6I+iFFBwI=";

  meta = {
    description = "Roon Remote for the terminal";
    homepage = "https://github.com/TheAppgineer/roon-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MichaelCDormann ];
    mainProgram = "roon-tui";
  };
}
