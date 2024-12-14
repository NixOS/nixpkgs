{
  lib,
  fetchFromGitHub,
  stdenv,
  rustPlatform,
  pkg-config,
  openssl,
  libgit2,
  Security,
  SystemConfiguration,
}:

rustPlatform.buildRustPackage rec {
  pname = "klipper-estimator";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "Annex-Engineering";
    repo = "klipper_estimator";
    rev = "v${version}";
    hash = "sha256-EjfW2qeq0ehGhjE2Psz5g/suYMZPvtQi2gaYb+NCa2U=";
  };

  cargoHash = "sha256-bboXG2nBrK2hVzB43um6EUgLPlSa8huyPH7VOJ48Nkk=";

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libgit2
      Security
      SystemConfiguration
    ];

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
