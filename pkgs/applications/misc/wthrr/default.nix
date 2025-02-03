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
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ttytm";
    repo = "wthrr-the-weathercrab";
    rev = "v${version}";
    hash = "sha256-3bWO2Gl8/B2p4k/6QhlT46RvyMJJs7WkVcX35vWN2Fk=";
  };

  cargoHash = "sha256-8Uy+8UpCQyLaLsulpgC1w2XI9aqj2P5ebBlXqpuDIc4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.SystemConfiguration
  ];

  checkFlags = [
    # requires internet access
    "--skip=modules::localization::tests::translate_string"
    "--skip=modules::location::tests::geolocation_response"
  ];

  meta = with lib; {
    description = "Weather companion for the terminal";
    homepage = "https://github.com/ttytm/wthrr-the-weathercrab";
    changelog = "https://github.com/ttytm/wthrr-the-weathercrab/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "wthrr";
  };
}
