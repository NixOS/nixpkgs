{
  lib,
  buildGo122Module,
  fetchFromGitHub,
}:
buildGo122Module rec {
  pname = "gptscript";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "gptscript-ai";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-zG75L10WvfkmjwW3ifBHaTkHNXqXvNO0PaXejCc2tls=";
  };

  vendorHash = "sha256-LV9uLLwdtLJTIxaBB1Jew92S0QjQsceyLEfSrDeDnR4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
    "-X main.Commit=${version}"
  ];

  # Requires network access
  doCheck = false;

  meta = with lib; {
    homepage = "https://gptscript.ai";
    changelog = "https://github.com/gptscript-ai/gptscript/releases/tag/v{version}";
    description = "Natural Language Programming";
    license = with licenses; [asl20];
    maintainers = with maintainers; [jamiemagee];
    mainProgram = "gptscript";
  };
}
