{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  pcsclite,
}:

rustPlatform.buildRustPackage rec {
  pname = "age-plugin-yubikey";
  version = "0.5.0-unstable-2024-11-02";

  src = fetchFromGitHub {
    owner = "str4d";
    repo = "age-plugin-yubikey";
    rev = "36290c74ebd2723832aae684d43b927c9104f744";
    hash = "sha256-vfemYGQnn3IzG7Y6iVKHZlYN+55/+A+N/GMG3TLs1h0=";
  };

  cargoHash = "sha256-CVbRKKX2A0MrHgjkjKAXhX80db1fimFlNxusvseUnxQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ pcsclite ];

  meta = with lib; {
    description = "YubiKey plugin for age";
    mainProgram = "age-plugin-yubikey";
    homepage = "https://github.com/str4d/age-plugin-yubikey";
    changelog = "https://github.com/str4d/age-plugin-yubikey/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      kranzes
      vtuan10
      adamcstephens
    ];
  };
}
