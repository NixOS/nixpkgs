{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, tailwindcss
, oniguruma
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-/tlGpsJ7qqBKC13w0kX2AqYyGR+KLNh+hM/FKjlEIaY=";
  };

  cargoHash = "sha256-cXf94Y9v80ofayJxzVTnrz0EpzWwhIH1CLvQIHDm1sw=";

  nativeBuildInputs = [
    pkg-config
    tailwindcss
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  # requires internet access
  checkFlags = [
    "--skip=build"
    "--skip=integration"
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    ORANDA_USE_TAILWIND_BINARY = true;
  } // lib.optionalAttrs stdenv.isDarwin {
    # without this, tailwindcss fails with OpenSSL configuration error
    OPENSSL_CONF = "";
  };

  meta = with lib; {
    description = "Generate beautiful landing pages for your developer tools";
    homepage = "https://github.com/axodotdev/oranda";
    changelog = "https://github.com/axodotdev/oranda/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
