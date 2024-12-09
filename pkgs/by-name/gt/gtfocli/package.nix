{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gtfocli";
  version = "0.0.5";

  src = fetchFromGitHub {
    owner = "cmd-tools";
    repo = "gtfocli";
    rev = "refs/tags/${version}";
    hash = "sha256-yvL9H9yOiYTaWtm5cj9A8y+kKXLQgLqUMu9JMnm1llI=";
  };

  vendorHash = "sha256-M1/XTY4ihkPNDiCv87I+kPgsTPU+sCqdnRoP09iVFu4=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "GTFO Command Line Interface for search binaries commands to bypass local security restrictions";
    homepage = "https://github.com/cmd-tools/gtfocli";
    changelog = "https://github.com/cmd-tools/gtfocli/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "gtfocli";
  };
}
