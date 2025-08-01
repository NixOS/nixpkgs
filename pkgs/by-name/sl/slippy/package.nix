{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "slippy";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "slippy";
    rev = "v${version}";
    hash = "sha256-7Uvo5+saxwTMQjfDliyOYC6j6LbpMf/FiONfX38xepI=";
  };

  cargoHash = "sha256-RGSc+jy2i97QZGfafe3M25bunBmCYAJ0UW3dAnvl5gs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Markdown slideshows in Rust";
    homepage = "https://github.com/axodotdev/slippy";
    changelog = "https://github.com/axodotdev/slippy/releases/tag/${src.rev}";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "slippy";
  };
}
