{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  sqlite,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "intelli-shell";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${finalAttrs.version}";
    hash = "sha256-/DkR2s6xHXhQxwJEEs4vXK7Zc4lwLQvBnqUqW75h0Do=";
  };

  cargoHash = "sha256-9/ZxPYgkETIKRizrlz+Pb9oWUYEeoSSmGk8EjzQO7PY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "extra-features"
  ];

  buildInputs = [
    libgit2
    openssl
    sqlite
    zlib
  ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "Like IntelliSense, but for shells";
    homepage = "https://github.com/lasantosr/intelli-shell";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lasantosr ];
    mainProgram = "intelli-shell";
  };
})
