{ lib
, fetchFromGitHub
, stdenv
, rustPlatform
, pkg-config
, openssl
, libgit2
, Security
, SystemConfiguration
}:

rustPlatform.buildRustPackage rec {
  pname = "klipper-estimator";
  version = "3.7.0";

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
    hash = "sha256-tGyqJtRKdfiWnf76F3W8P5XoLLMTrPWGlZ7Kwn8n/XQ=";
  };

  cargoHash = "sha256-ztGPqnZfP55WXfiKDSacdsalkDVuiLcfo3g4CtkFUXc=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ libgit2 Security SystemConfiguration ];

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
