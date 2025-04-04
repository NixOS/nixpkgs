{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "gotify-desktop";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = version;
    sha256 = "sha256-P6zZAd3381/JamrEdbZRVFouhDsPNy1cNAjy4K3jGro=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-od8eaOwf5k//HuzD4CNCOu8JGJv1P1TJTW0shgEnFDc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      bryanasdev000
      genofire
    ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "gotify-desktop";
  };
}
