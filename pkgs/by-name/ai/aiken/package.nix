{ lib
, openssl
, pkg-config
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "aiken";
  version = "1.0.24-alpha"; # all releases are 'alpha'

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    rev = "v${version}";
    hash = "sha256-MJJuqP/2b9qQp7GkDxFCz5MPU14lXJIL4q51/4krQ88=";
  };

  cargoHash = "sha256-3cpurOGwluYTW8sqqlikzZFQUirRxdSK8l8S9KuWSzI=";

  buildInputs = [
    openssl
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  meta = {
    description = "A modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ t4ccer ];
    mainProgram = "aiken";
  };
}
