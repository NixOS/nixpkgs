{
  lib,
  fetchFromGitHub,
  rustPlatform,

  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "smartcat";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "efugier";
    repo = "smartcat";
    tag = version;
    hash = "sha256-nXuMyHV5Sln3qWXIhIDdV0thSY4YbvzGqNWGIw4QLdM=";
  };

  cargoHash = "sha256-AiOVIDfARztwQxOzBFWc8NXEEsxEvKAStCokcRrJyOE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = "Integrate large language models into the command line";
    homepage = "https://github.com/efugier/smartcat";
    changelog = "https://github.com/efugier/smartcat/releases/tag/v${version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "sc";
    maintainers = with lib.maintainers; [ lpchaim ];
  };
}
