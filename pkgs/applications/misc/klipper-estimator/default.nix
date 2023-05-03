{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, pkg-config
, openssl
, libgit2
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "klipper-estimator";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
    hash = "sha256-0QDEaRJpjiE7aH6PpessCGUe4TT31FhsxTFw7OglPUc=";
  };

  cargoHash = "sha256-W0Vo4bA2QNfzBqcZiblf6eJnQ3cRgrnNELzS9O1O6bU=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libgit2 Security ];

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Tool for determining the time a print will take using the Klipper firmware";
    homepage = "https://github.com/Annex-Engineering/klipper_estimator";
    changelog = "https://github.com/Annex-Engineering/klipper_estimator/releases/tag/v${version}";
    mainProgram = "klipper_estimator";
    license = licenses.mit;
    maintainers = with maintainers; [ tmarkus ];
  };
}
