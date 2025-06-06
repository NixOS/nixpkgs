{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "roon-tui";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "TheAppgineer";
    repo = "roon-tui";
    rev = version;
    hash = "sha256-rwZPUa6NyKs+jz0+JQC0kSrw0T/EL+ms2m+AzHvrI7o=";
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
