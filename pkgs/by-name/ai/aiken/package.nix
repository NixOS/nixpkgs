{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aiken";
  version = "1.1.23";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9CPwIqUoOih4711vSEeV3AX1T1GGQ/AeYj7HnWI5UO8=";
  };

  cargoHash = "sha256-98oyeVo3z49DGikhSBMB7QSiz6+I7GkvqJIpOusuEz4=";

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
