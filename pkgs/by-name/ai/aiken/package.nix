{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aiken";
  version = "1.1.24";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yG96JwZ/H4/MrLkrmsResRg3HGUfh1Kz3kA6qv0Y62c=";
  };

  cargoHash = "sha256-BDe1GQtKzE2fyKPDdOEriF4wUxONe/jLfnyHiF/dUh4=";

  buildInputs = [ openssl ];

  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Modern smart contract platform for Cardano";
    homepage = "https://aiken-lang.org";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aciceri ];
    mainProgram = "aiken";
  };
})
