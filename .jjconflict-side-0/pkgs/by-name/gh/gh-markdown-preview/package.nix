{
  lib,
  fetchFromGitHub,
  buildGoModule,
  gh-markdown-preview,
  testers,
}:

buildGoModule rec {
  pname = "gh-markdown-preview";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "yusukebe";
    repo = "gh-markdown-preview";
    rev = "v${version}";
    hash = "sha256-y9AiHmBfDSJ6oCevUAUkg18qHe/oP7A6PLiz3MZqU0s=";
  };

  vendorHash = "sha256-O6Q9h5zcYAoKLjuzGu7f7UZY0Y5rL2INqFyJT2QZJ/E=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/yusukebe/gh-markdown-preview/cmd.Version=${version}"
  ];

  # Tests need network
  doCheck = false;

  passthru.tests = {
    version = testers.testVersion { package = gh-markdown-preview; };
  };

  meta = {
    description = "gh extension to preview Markdown looking like on GitHub";
    homepage = "https://github.com/yusukebe/gh-markdown-preview";
    changelog = "https://github.com/yusukebe/gh-markdown-preview/releases/tag/${src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ amesgen ];
    mainProgram = "gh-markdown-preview";
  };
}
