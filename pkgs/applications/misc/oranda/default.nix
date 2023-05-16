{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
<<<<<<< HEAD
, oniguruma
, stdenv
, darwin
, tailwindcss
=======
, bzip2
, oniguruma
, openssl
, xz
, zstd
, stdenv
, darwin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "oranda";
<<<<<<< HEAD
  version = "0.3.1";
=======
  version = "0.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "axodotdev";
    repo = "oranda";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-v/4FPDww142V5mx+pHhaHkDiIUN70dwei8mTeZELztc=";
  };

  cargoHash = "sha256-Q5EY9PB50DxFXFTPiv3RktI37b2TCDqLVNISxixnspY=";

  patches = [
    # oranda-generate-css which is used in the build script tries to download
    # tailwindcss from the internet, so we have to patch it to use the
    # tailwindcss from nixpkgs
    ./tailwind.patch
  ];
=======
    hash = "sha256-MT0uwLDrofCFyyYiUOogF2kNs6EPS1qxPz0gdK+Tkkg=";
  };

  cargoHash = "sha256-dAnZc1VvOubfn7mnpttaB6FotN3Xc+t9Qn0n5uzv1Qg=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
<<<<<<< HEAD
    oniguruma
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
=======
    bzip2
    oniguruma
    openssl
    xz
    zstd
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # requires internet access
  checkFlags = [
    "--skip=build"
<<<<<<< HEAD
    "--skip=integration"
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
<<<<<<< HEAD
    TAILWINDCSS = lib.getExe tailwindcss;
  } // lib.optionalAttrs stdenv.isDarwin {
    # without this, tailwindcss fails with OpenSSL configuration error
    OPENSSL_CONF = "";
=======
    ZSTD_SYS_USE_PKG_CONFIG = true;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  meta = with lib; {
    description = "Generate beautiful landing pages for your developer tools";
    homepage = "https://github.com/axodotdev/oranda";
    changelog = "https://github.com/axodotdev/oranda/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
