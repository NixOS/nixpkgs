{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  openssl,
  rage,
}:

rustPlatform.buildRustPackage rec {
  pname = "age-plugin-ledger";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Ledger-Donjon";
    repo = "age-plugin-ledger";
    tag = "v${version}";
    hash = "sha256-g5GbWXhaGEafiM3qkGlRXHcOzPZl2pbDWEBPg4gQWcg=";
  };

  cargoHash = "sha256-zR7gJNIqno50bQo0kondCxEC0ZgssqXNqACF6fnLDrc=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libusb1
    openssl
  ];

  nativeCheckInputs = [
    rage
  ];

  meta = with lib; {
    description = "Ledger Nano plugin for age";
    mainProgram = "age-plugin-ledger";
    homepage = "https://github.com/Ledger-Donjon/age-plugin-ledger";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [ erdnaxe ];
  };
}
