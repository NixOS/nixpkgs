{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  pkg-config,
  openssl,
  rust-jemalloc-sys,
}:

rustPlatform.buildRustPackage rec {
  pname = "oha";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = "oha";
    tag = "v${version}";
    hash = "sha256-ZUZee+jEhTaVGwYtNvYHckdLxb9axOsLUYkKrd07Zvg=";
  };

  cargoHash = "sha256-HUy41huDWTmpdPkcCB4Kti7oAI7M5q5gB8u/UZlLrU4=";

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    rust-jemalloc-sys
  ];

  # tests don't work inside the sandbox
  doCheck = false;

  meta = {
    description = "HTTP load generator inspired by rakyll/hey with tui animation";
    homepage = "https://github.com/hatoo/oha";
    changelog = "https://github.com/hatoo/oha/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "oha";
  };
}
