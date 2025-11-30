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
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "hatoo";
    repo = "oha";
    tag = "v${version}";
    hash = "sha256-GDFS/f9fombAEXEf0f/issQFrFviU1nsLOIQ5nthPHk=";
  };

  cargoHash = "sha256-pZnHE89kwuByMtm5m9QLSuhJ6wxFrbVOShF7T6c2494=";

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
    maintainers = [ ];
    mainProgram = "oha";
  };
}
