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
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "gotify-desktop";
    rev = version;
    sha256 = "sha256-BD8BqG+YheAGvHWrI1/PqCs6T3O3OwXodZq3gvgh1LU=";
  };

  cargoHash = "sha256-CHo3TYNpXdU3g7vKEwmubPKy+COSZ9Ay77nW8IlK9H4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Small Gotify daemon to send messages as desktop notifications";
    homepage = "https://github.com/desbma/gotify-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      genofire
    ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "gotify-desktop";
  };
}
