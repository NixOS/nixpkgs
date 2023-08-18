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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
    hash = "sha256-R9b2T/Em3s4hwcXa3l2i8A3w/aBu0Dz+izFcE4Q8J/4=";
  };

  cargoHash = "sha256-0eH7LZfO5/YgXP9Hom7pgALKFksSTAiczgT7rrNnqow=";

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
