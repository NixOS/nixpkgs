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
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "tobealive";
    repo = "wthrr-the-weathercrab";
    rev = "v${version}";
    hash = "sha256-JHSUjQJyi5vHfUtKEGwO9EXqKT4EwFtrVnK/iNEPkYM=";
  };

  cargoHash = "sha256-OUn40cKutFSW4hMSKyUqcI1oqKBHnm2+wVi09ZED4qA=";

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
