{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kulala-fmt";
  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "mistweaverco";
    repo = "kulala-fmt";
    rev = "v${version}";
    hash = "sha256-VWd+lUPRgDVaM8nnwah/dXjQeHsLD3OM2D8coEJDCu4=";
  };

  vendorHash = "sha256-GazDEm/qv0nh8vYT+Tf0n4QDGHlcYtbMIj5rlZBvpKo=";

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
