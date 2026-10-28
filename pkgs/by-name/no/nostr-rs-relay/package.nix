{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  libiconv,
  protobuf,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nostr-rs-relay";
  version = "0.10.0";
  src = fetchFromGitHub {
    owner = "scsibug";
    repo = "nostr-rs-relay";
    rev = finalAttrs.version;
    hash = "sha256-HNAoCb6NHfSXpz+qDsxeqSiV8ydd4f9/t5JfS5p9af4=";
  };

  cargoHash = "sha256-zLLkAj1Kahkrahru7STSSdyzsLihc3z34c4v5BrFXvU=";

  buildInputs = [
    openssl.dev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [
    pkg-config # for openssl
    protobuf
  ];

  meta = {
    description = "Nostr relay written in Rust";
    homepage = "https://sr.ht/~gheartsfield/nostr-rs-relay/";
    changelog = "https://github.com/scsibug/nostr-rs-relay/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ jurraca ];
    license = lib.licenses.mit;
  };
})
