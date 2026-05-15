{
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "aiken";
  version = "1.1.22";

  src = fetchFromGitHub {
    owner = "aiken-lang";
    repo = "aiken";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mq/NwfSjqykYwyKq63jDs7u21uWxzAtwDKbZ9Fn3i90=";
  };

  cargoHash = "sha256-WzaprYYTFLaM6TKzUG6JadQNLBHjgoM3FwRUfMTmiHA=";

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
