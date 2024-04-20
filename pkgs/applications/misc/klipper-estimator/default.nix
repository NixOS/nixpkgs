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
  version = "3.7.2";

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
    hash = "sha256-OvDdANowsz3qU2KV4WbUWyDrh3sG02+lBKNtcq6ecZ8=";
  };

  cargoHash = "sha256-1O3kXeGPALSa/kNWRArk6ULG0+3UgTxVBzrsqDHHpDU=";

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
