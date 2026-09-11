{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libusb1,
  openssl,
  rage,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "age-plugin-ledger";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "Ledger-Donjon";
    repo = "age-plugin-ledger";
    tag = "v${finalAttrs.version}";
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

  # rage (used in tests) panics on locale detection in the Nix sandbox without
  # a valid LANG set.
  preCheck = lib.optionalString stdenv.hostPlatform.isDarwin ''
    export LANG=en_US.UTF-8
  '';

  nativeCheckInputs = [
    rage
  ];

  meta = {
    description = "Ledger Nano plugin for age";
    mainProgram = "age-plugin-ledger";
    homepage = "https://github.com/Ledger-Donjon/age-plugin-ledger";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ erdnaxe ];
  };
})
