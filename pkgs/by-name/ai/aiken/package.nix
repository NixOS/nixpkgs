{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aiken";
  version = "1.1.21";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8Oq6Bem4mREHXsBC0FwBnU2MVmTh8b7KtJ/KrPDMqLU=";
  };

  cargoHash = "sha256-5TplKj7q8G1XX6o4d8Vlgf5eGXB8fpnvkl7TwVcuTw0=";

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
