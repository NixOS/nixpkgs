{ lib
, rustPlatform
, fetchFromGitHub
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

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "roon-api-0.1.1" = "sha256-aFcS8esfgMxzzhWLeynTRFp1FZj2z6aHIivU/5p+uec=";
    };
  };

  meta = {
    description = "Roon Remote for the terminal";
    homepage = "https://github.com/TheAppgineer/roon-tui";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MichaelCDormann ];
    mainProgram = "roon-tui";
  };
}
