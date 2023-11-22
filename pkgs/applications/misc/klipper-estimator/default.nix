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
  version = "3.6.0";

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
    hash = "sha256-1Od4sIHrg52DezV5DCg2NVv/2nbXQW3fK6f9aqVmlTk=";
  };

  cargoHash = "sha256-5O2KUTegK5ArTalJ57/Kn9lzlkmAIXnzluljvfrIc5U=";

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
