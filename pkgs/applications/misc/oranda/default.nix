{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, oniguruma
, stdenv
, darwin
, tailwindcss
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-v/4FPDww142V5mx+pHhaHkDiIUN70dwei8mTeZELztc=";
  };

  cargoHash = "sha256-Q5EY9PB50DxFXFTPiv3RktI37b2TCDqLVNISxixnspY=";

  patches = [
    # oranda-generate-css which is used in the build script tries to download
    # tailwindcss from the internet, so we have to patch it to use the
    # tailwindcss from nixpkgs
    ./tailwind.patch
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  # requires internet access
  checkFlags = [
    "--skip=build"
    "--skip=integration"
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
    TAILWINDCSS = lib.getExe tailwindcss;
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
