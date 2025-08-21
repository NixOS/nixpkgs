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

rustPlatform.buildRustPackage rec {
  pname = "nostr-rs-relay";
  version = "0.9.0";
  src = fetchFromGitHub {
    owner = "scsibug";
    repo = "nostr-rs-relay";
    rev = version;
    hash = "sha256-MS5jgUh9aLAFr4Nnf3Wid+ki0PTfsyob3r16/EXYZ7E=";
  };

  cargoHash = "sha256-hrq9EEUot9painlXVGjIh+NMlrH4iRQ28U3PLGnvYsw=";

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
    changelog = "https://github.com/scsibug/nostr-rs-relay/releases/tag/${version}";
    maintainers = with lib.maintainers; [ jurraca ];
    license = lib.licenses.mit;
  };
}
