{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  libiconv,
  darwin,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitrs";
  version = "v0.3.6";

  src = fetchFromGitHub {
    owner = "mccurdyc";
    repo = pname;
    rev = version;
    hash = "sha256-+43XJroPNWmdUC6FDL84rZWrJm5fzuUXfpDkAMyVQQg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uDDk1wztXdINPSVF6MvDy+lHIClMLp13HZSTpIgLypM=";

  nativeBuildInputs = [
    pkg-config # for openssl
  ];

  buildInputs =
    [ openssl.dev ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libiconv
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    description = "Simple, opinionated, tool, written in Rust, for declaratively managing Git repos on your machine";
    homepage = "https://github.com/mccurdyc/gitrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mccurdyc ];
    mainProgram = "gitrs";
  };
}
