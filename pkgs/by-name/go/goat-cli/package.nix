{
  lib,
  fetchFromGitHub,
  buildGoModule,
  fetchpatch,
}:

buildGoModule rec {
  pname = "goat-cli";
  version = "1.1.0";

  src = fetchFromGitHub {
    repo = "goat";
    owner = "studio-b12";
    rev = "v${version}";
    hash = "sha256-H7ea3XOBfQ7bIX5SbxPd+fcSlMurSWXGXe+/LsqSc0A=";
  };

  vendorHash = "sha256-DtEXgGYSkWO876so6LEOkhVwDt/zrflDZdY4O2lz1mw=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/studio-b12/goat/internal/version.Version=${version}"
    "-X github.com/studio-b12/goat/internal/version.CommitHash=${src.rev}"
  ];

  patches = [
    ./mock-fix.patch
  ];

  # Checks currently fail because of an issue with github.com/studio-b12/goat/mocks
  doCheck = false;

  meta = {
    description = "Integration testing tool for HTTP APIs using a simple script language";
    homepage = "https://studio-b12.github.io/goat/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kashw2 ];
    mainProgram = "goat";
  };

}
