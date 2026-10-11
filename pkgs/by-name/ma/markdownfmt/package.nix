{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "markdownfmt";
  version = "1.1-unstable-2026-10-10"; # Last release is from 12 years ago

  src = fetchFromGitHub {
    owner = "shurcooL";
    repo = "markdownfmt";
    rev = "c8f16ef0855c74a8dc9f845f9170b24fb47a15e7";
    hash = "sha256-bwZKWAyZaGrMQ6bCe77gVszKtATbrKo0/FEvQ7rWz/M=";
  };

  vendorHash = "sha256-tKguLJIbivPLp7ThA1KYX9LSViNJQkNZ1mzXC6+q+QY=";

  patches = [
    ./dependencies.patch
  ];

  ldflags = [
    "-s"
  ];

  meta = {
    description = "Markdown formatter. Like gofmt, but for markdown";
    homepage = "https://github.com/shurcooL/markdownfmt";
    license = lib.licenses.mit;
    mainProgram = "markdownfmt";
    maintainers = with lib.maintainer; [
      arne-zillhardt
    ];
  };
}
