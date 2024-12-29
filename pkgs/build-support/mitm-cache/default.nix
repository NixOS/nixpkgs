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
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "chayleaf";
    repo = "mitm-cache";
    rev = "v${version}";
    hash = "sha256-l9dnyA4Zo4jlbiCMRzUqW3NkiploVpmvxz9i896JkXU=";
  };

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  cargoHash = "sha256-6eYOSSlswJGR2IrFo17qVnwI+h2FkyTjLFvwf62nG2c=";

  setupHook = substituteAll {
    src = ./setup-hook.sh;
    inherit openssl;
    ephemeral_port_reserve = python3Packages.ephemeral-port-reserve;
  };

  passthru.fetch = callPackage ./fetch.nix { };

  meta = with lib; {
    description = "A MITM caching proxy for use in nixpkgs";
    homepage = "https://github.com/chayleaf/mitm-cache#readme";
    license = licenses.mit;
    maintainers = with maintainers; [ chayleaf ];
    mainProgram = "mitm-cache";
  };
}
