{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  tailwindcss,
  oniguruma,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
  version = "0.6.5";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-FVd8NQVtzlZsDY40ZMJDdaX+6Q5jUxZHUq2v+kDFVOk=";
  };

  cargoHash = "sha256-wPYgAbaoUVJoZT1nRCBsPziszkAubImZEKGrC2RAkEA=";

  nativeBuildInputs = [
    pkg-config
    tailwindcss
  ];

  buildInputs = [
    oniguruma
  ];

  # requires internet access
  checkFlags = [
    "--skip=build"
    "--skip=integration"
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ORANDA_USE_TAILWIND_BINARY = true;
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # without this, tailwindcss fails with OpenSSL configuration error
    OPENSSL_CONF = "";
  };

  meta = with lib; {
    description = "Generate beautiful landing pages for your developer tools";
    homepage = "https://github.com/axodotdev/oranda";
    changelog = "https://github.com/axodotdev/oranda/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "oranda";
  };
}
