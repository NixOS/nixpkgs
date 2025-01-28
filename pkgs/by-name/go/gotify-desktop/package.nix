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
    repo = pname;
    rev = version;
    sha256 = "sha256-P6zZAd3381/JamrEdbZRVFouhDsPNy1cNAjy4K3jGro=";
  };

  cargoHash = "sha256-YdvPcg16C7WNHaKdLMXGZoouGFOJ5Z927SMxHL/pwmY=";

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
