{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "poutine";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    rev = "refs/tags/v${version}";
    hash = "sha256-T81Qi79VaZzfKL4niTZQW+gwwiBcyInALrvyUg1V4Ck=";
  };

  vendorHash = "sha256-/chq40j+puAI3KdI15vbZwrnzCKrU7g+Z/t9aOXQ1Sg=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "Security scanner that detects misconfigurations and vulnerabilities in build pipelines of repositories";
    homepage = "https://github.com/boostsecurityio/poutine";
    changelog = "https://github.com/boostsecurityio/poutine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "poutine";
  };
}
