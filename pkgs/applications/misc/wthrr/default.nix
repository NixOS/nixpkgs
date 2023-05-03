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
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "tobealive";
    repo = "wthrr-the-weathercrab";
    rev = "v${version}";
    hash = "sha256-iyla63CbsYavPRbkrnqr3gyULyWbvUKc3evKaB/W9jU=";
  };

  cargoHash = "sha256-izJ0TT69QnnOTLOGi1bqvy0AHJw1mMI/io5twa2Y4x0=";

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
