{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ghciwatch";
  version = "0.5.11";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${version}";
    hash = "sha256-lWeQ0nBJDUJ9c915WWy/YsIoWwtipz5ns2xvFJSD9LQ=";
  };

  cargoHash = "sha256-1jcdhTLCdCOh3EHywlFi83KupmWX4hGvB2/LhtzUPRk=";

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
