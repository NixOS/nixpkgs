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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitrs";
  version = "v0.3.6";

  src = fetchFromGitHub {
    owner = "mccurdyc";
    repo = "gitrs";
    rev = finalAttrs.version;
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

  meta = {
    description = "Simple, opinionated, tool, written in Rust, for declaratively managing Git repos on your machine";
    homepage = "https://github.com/mccurdyc/gitrs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mccurdyc ];
    mainProgram = "gitrs";
  };
})
