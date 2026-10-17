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
  version = "v0.4.1";

  src = fetchFromGitHub {
    owner = "mccurdyc";
    repo = "gitrs";
    rev = finalAttrs.version;
    hash = "sha256-YxojhqcP5Jj+GUhZxwyz1WXpRrTc4mZKxJbJdbnEZ48=";
  };

  cargoHash = "sha256-uxK7HSP7rTPsnSwgj8pJRdXR2N9xqx21TycTRCjdAGo=";

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
