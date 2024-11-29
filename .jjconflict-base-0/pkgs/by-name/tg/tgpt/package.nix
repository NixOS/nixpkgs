{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "tgpt";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "aandrew-me";
    repo = "tgpt";
    rev = "refs/tags/v${version}";
    hash = "sha256-Nk+iLsTXnw6RAc1VztW8ZqeUVsywFjMCOBY2yuWbUXQ=";
  };

  vendorHash = "sha256-docq/r6yyMPsuUyFbtCMaYfEVL0gLmyTy4PbrAemR00=";

  ldflags = [
    "-s"
    "-w"
  ];

  preCheck = ''
    # Remove test which need network access
    rm providers/koboldai/koboldai_test.go
  '';

  meta = with lib; {
    description = "ChatGPT in terminal without needing API keys";
    homepage = "https://github.com/aandrew-me/tgpt";
    changelog = "https://github.com/aandrew-me/tgpt/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "tgpt";
  };
}
