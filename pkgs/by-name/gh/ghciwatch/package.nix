{ lib
, rustPlatform
, fetchFromGitHub
, nix-update-script
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "ghciwatch";
  version = "0.5.16";

  src = fetchFromGitHub {
    owner = "MercuryTechnologies";
    repo = "ghciwatch";
    rev = "v${version}";
    hash = "sha256-XKR/X27oScB9XdyXeYKD6nlnkBTLJLXkzsRgfS3ygVE=";
  };

  cargoHash = "sha256-BKPzOv2RtcE4MzRyvHs3VmNME2uKtGXCqGrULfryacM=";

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
