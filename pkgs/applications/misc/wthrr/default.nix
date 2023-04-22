{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "wthrr";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "tobealive";
    repo = "wthrr-the-weathercrab";
    rev = "v${version}";
    hash = "sha256-u8d3bX0jRe8N7LIhENMVI9MyR5HF2a8kyuMYw8s+PSc=";
  };

  cargoHash = "sha256-mrPydD45L51OSrVPYpXLli1rPlmUpKMcPWql1XrZu1Y=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # requires internet access
    "--skip=modules::localization::tests::translate_string"
    "--skip=modules::location::tests::geolocation_response"
  ];

  meta = with lib; {
    description = "Weather companion for the terminal";
    homepage = "https://github.com/tobealive/wthrr-the-weathercrab";
    changelog = "https://github.com/tobealive/wthrr-the-weathercrab/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
  };
}
