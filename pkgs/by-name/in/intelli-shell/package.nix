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
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${version}";
    hash = "sha256-gahf7Ijaj2mf9cdE3C4IIyW5UJrs0IbOP3vado/0fXw=";
  };

  cargoHash = "sha256-skxgDsDicqkA92IaePwCndGuKHov4GNtwXkSbrDlG2A=";

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
