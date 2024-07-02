{ lib
, stdenv
, fetchFromGitHub
, callPackage
, rustPlatform
, substituteAll
, openssl
, Security
, python3Packages
}:

rustPlatform.buildRustPackage rec {
  pname = "mitm-cache";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "chayleaf";
    repo = "mitm-cache";
    rev = "v${version}";
    hash = "sha256-/0cOtYERhG8brnqaPbWRxRA7ZHNBiU5x3DwobgOp6XI=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-pltVvzX4t1oL06pYaEIaqZ9ki8Vj78lglYRDUdS4mH8=";

  setupHook = substituteAll {
    src = ./setup-hook.sh;
    inherit openssl;
    ephemeral_port_reserve = python3Packages.ephemeral-port-reserve;
  };

  passthru.fetch = callPackage ./fetch.nix { };

  meta = with lib; {
    description = "A MITM caching proxy for use in nixpkgs";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
    mainProgram = "mitm-cache";
  };
}
