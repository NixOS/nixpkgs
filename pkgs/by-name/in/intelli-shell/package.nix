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

rustPlatform.buildRustPackage rec {
  pname = "intelli-shell";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${version}";
    hash = "sha256-Y1wFmere1Ft7AB1voHpI7KThoGjSpRXmAab35uoM6Ms=";
  };

  cargoHash = "sha256-Op96deiAVliE9FuNMh1GExoO0jcmCFEuYGCXMccHAvo=";

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

  meta = with lib; {
    description = "Like IntelliSense, but for shells";
    homepage = "https://github.com/lasantosr/intelli-shell";
    license = licenses.asl20;
    maintainers = with maintainers; [ lasantosr ];
    mainProgram = "intelli-shell";
  };
}
