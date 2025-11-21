{
  lib,
  buildGoModule,
  fetchFromGitLab,
}:

buildGoModule rec {
  pname = "regex2json";
  version = "0.11.0";

  src = fetchFromGitLab {
    owner = "tozd";
    repo = "regex2json";
    rev = "v${version}";
    hash = "sha256-WoxrwAH2ocDuwRj52QHPN3sOMXIF3ygzKeb83BKZqKo=";
  };

  vendorHash = "sha256-myMUs9urHjYaOQ/UaPYlLZstvClOuvF5xJao4lTP5bY=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Convert text to JSON using only regular expressions";
    homepage = "https://gitlab.com/tozd/regex2json";
    changelog = "https://gitlab.com/tozd/regex2json/-/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nagy ];
    mainProgram = "regex2json";
  };
}
