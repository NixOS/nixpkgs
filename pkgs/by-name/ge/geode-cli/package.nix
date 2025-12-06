{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "geode-cli";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "geode-sdk";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-driGxdkXSjKS/WOhmhcyVETmvSsNfR/fFKaLs7Jpp+M=";
  };

  cargoHash = "sha256-VeKXoCHPwtnCxds7PDIJmjTfun6qs/Od1NkaVgTtOxc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Command-line utilities for working with geode";
    homepage = "https://github.com/geode-sdk/cli";
    changelog = "https://github.com/geode-sdk/cli/releases/tag/v${version}";
    license = lib.licenses.boost;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ not-a-cow ];
    mainProgram = "geode";
  };
}
