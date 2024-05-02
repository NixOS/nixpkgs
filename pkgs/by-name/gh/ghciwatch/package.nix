{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ghciwatch";
  version = "0.5.10";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${version}";
    hash = "sha256-6afUHLPrSWhgN5LA346tAZ1+gROr+i/ZyCNVnyCd5Tc=";
  };

  cargoHash = "sha256-og7S3W+DCBlFIvKLZghLT+msBLnS1o7Rea7v2VPsDYA=";

  buildInputs = lib.optionals stdenv.isDarwin [
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
    maintainers = with maintainers; [ mangoiv _9999years ];
    mainProgram = "ghciwatch";
  };

  passthru.updateScript = nix-update-script { };
}
