{
  lib,
  fetchFromGitea,
  rustPlatform,
  pkg-config,
  openssl,
}:
rustPlatform.buildRustPackage rec {
  pname = "pay-respects";
  version = "0.6.10";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "iff";
    repo = "pay-respects";
    rev = "v${version}";
    hash = "sha256-cyd0MF5pxa3FhSUmjNtiIwAWrE0/rqtOm8dJxqdwPSk=";
  };

  cargoHash = "sha256-7j6rRCMazMFbPnzt4/0Lz1BDJP3xtq1ycb+41f2qhe0=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = with lib; {
    description = "Terminal command correction, alternative to `thefuck`, written in Rust";
    homepage = "https://codeberg.org/iff/pay-respects";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [
      sigmasquadron
      bloxx12
    ];
    mainProgram = "pay-respects";
  };
}
