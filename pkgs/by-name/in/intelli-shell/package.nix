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
  version = "3.2.3";

  src = fetchFromGitHub {
    owner = "lasantosr";
    repo = "intelli-shell";
    rev = "v${version}";
    hash = "sha256-kwwZzuo/eH+bssSFjBWC3YwP6X/CoRPo8OCa/0wGrp8=";
  };

  cargoHash = "sha256-0wS751jE0VK/FaoL7WNc2OezJeDmYJNO+IKezB7Ma1Q=";

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
