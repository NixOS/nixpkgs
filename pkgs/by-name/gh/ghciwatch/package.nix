{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "ghciwatch";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${version}";
    hash = "sha256-LE2QiqPjn3tLnGUC0EjfrTPmYrPt8Mt9TgVOM+uX2xM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-P4zpGuKE6KDG3Zrgp0TStbQmW28bQZCyCmUsoJiKwiU=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # integration tests are not run but the macros need this variable to be set
  GHC_VERSIONS = "";
  checkFlags = "--test \"unit\"";

  meta = with lib; {
    description = "Ghci-based file watching recompiler for Haskell development";
    homepage = "https://github.com/MercuryTechnologies/ghciwatch";
    license = licenses.mit;
    maintainers = with maintainers; [
      mangoiv
      _9999years
    ];
    mainProgram = "ghciwatch";
  };

  passthru.updateScript = nix-update-script { };
}
