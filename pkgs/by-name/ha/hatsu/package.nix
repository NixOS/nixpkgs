{
  cmake,
  fetchFromGitHub,
  gitUpdater,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "hatsu";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "importantimport";
    repo = "hatsu";
    rev = "v${version}";
    hash = "sha256-iQrwqv5q002rJMcvUhlsLVN3O7mHyL5zmLGjegZDVG0=";
  };

  cargoHash = "sha256-LkGkifmHy7cEGrPg0WCf1nCGfcW60AGWQSB0Zb01mk0=";

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
    ignoredVersions = "beta";
  };

  meta = {
    description = "Self-hosted and fully-automated ActivityPub bridge for static sites";
    homepage = "https://github.com/importantimport/hatsu";
    license = lib.licenses.agpl3Only;
    mainProgram = "hatsu";
    maintainers = with lib.maintainers; [ kwaa ];
    platforms = lib.platforms.linux;
  };
}
