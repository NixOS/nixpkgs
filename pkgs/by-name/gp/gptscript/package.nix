{
  lib,
  buildGo122Module,
  fetchFromGitHub,
}:
buildGo122Module rec {
  pname = "gptscript";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-teZQhGYKJ5Ma5by3Wug5B1hAV1tox94MF586ZeEXp6o=";
  };

  vendorHash = "sha256-0irUcEomQzo9+vFJEk28apLNuJdsX1RHEqB7T88X7Ks=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gptscript-ai/gptscript/pkg/version.Tag=v${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://gptscript.ai";
    changelog = "https://github.com/gptscript-ai/gptscript/releases/tag/v{version}";
    description = "Natural Language Programming";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ jamiemagee ];
    mainProgram = "gptscript";
  };
}
