{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  pkg-config,
  libiconv,
  rustPlatform,
  libz,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitrs";
  version = "v0.3.6";

  src = fetchFromGitHub {
    owner = "mccurdyc";
    repo = "gitrs";
    rev = version;
    hash = "sha256-+43XJroPNWmdUC6FDL84rZWrJm5fzuUXfpDkAMyVQQg=";
  };

  cargoHash = "sha256-uDDk1wztXdINPSVF6MvDy+lHIClMLp13HZSTpIgLypM=";

  nativeBuildInputs = [
    pkg-config # for openssl
  ];

  buildInputs = [
    openssl.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
    libz
  ];

  meta = with lib; {
    description = "Simple, opinionated, tool, written in Rust, for declaratively managing Git repos on your machine";
    homepage = "https://github.com/mccurdyc/gitrs";
    license = licenses.mit;
    maintainers = with maintainers; [ mccurdyc ];
    mainProgram = "gitrs";
  };
}
