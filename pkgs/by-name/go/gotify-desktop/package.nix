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
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = version;
    sha256 = "sha256-QhzvY7MeOvrL+xxeV7gPXWRo3EinMMdS9A7oh38gYjU=";
  };

  cargoHash = "sha256-fNOC8atr5/LgQcGf9jdxec9AQt3YIR+hem/xL10YYqY=";

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
