{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kulala-fmt";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-fmt";
    rev = "v${version}";
    hash = "sha256-Fxxc8dJMiL7OVoovOt58vVaUloRjJX5hc8xSlzkwVc8=";
  };

  vendorHash = "sha256-uA29P6bcZNfxWsTfzsADBIqYgyfVX8dY8y70ZJKieas=";

  CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
    "-X github.com/mistweaverco/kulala-fmt/cmd/kulalafmt.VERSION=${version}"
  ];

  meta = {
    description = "Opinionated .http and .rest files linter and formatter";
    homepage = "https://github.com/mistweaverco/kulala-fmt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CnTeng ];
    mainProgram = "kulala-fmt";
    platforms = lib.platforms.all;
  };
}
