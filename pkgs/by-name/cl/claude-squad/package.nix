{
  lib,
  buildGoModule,
  fetchFromGitHub,
  tmux,
  gh,
}:

buildGoModule rec {
  pname = "claude-squad";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "smtg-ai";
    repo = "claude-squad";
    rev = "v${version}";
    hash = "sha256-mzW9Z+QN4EQ3JLFD3uTDT2/c+ZGLzMqngl3o5TVBZN0=";
  };

  vendorHash = "sha256-BduH6Vu+p5iFe1N5svZRsb9QuFlhf7usBjMsOtRn2nQ=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [
    tmux
    gh
  ];

  postInstall = ''
    mv $out/bin/claude-squad $out/bin/cs
  '';

  meta = with lib; {
    description = "Terminal application for managing multiple AI coding agents in isolated workspaces";
    homepage = "https://github.com/smtg-ai/claude-squad";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ ];
    mainProgram = "cs";
    platforms = platforms.unix;
  };
}