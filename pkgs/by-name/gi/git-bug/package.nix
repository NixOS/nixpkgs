{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "git-bug";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "git-bug";
    repo = "git-bug";
    rev = "v${version}";
    sha256 = "sha256-lfvHoXbanisq6MaVXlwKmW8YTeWjx6E6b4N9xICemKc=";
  };

  vendorHash = "sha256-z9StU5cvZlDkmC7TE6JOhpxAx5oSTxAQTBh1LEksKww=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  excludedPackages = [
    "doc"
    "misc"
  ];

  ldflags = [
    "-X github.com/MichaelMure/git-bug/commands.GitCommit=v${version}"
    "-X github.com/MichaelMure/git-bug/commands.GitLastTag=${version}"
    "-X github.com/MichaelMure/git-bug/commands.GitExactTag=${version}"
  ];

  postInstall = ''
    installShellCompletion \
      --bash misc/completion/bash/git-bug \
      --zsh misc/completion/zsh/git-bug \
      --fish misc/completion/fish/git-bug

    installManPage doc/man/*
  '';

  meta = with lib; {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/git-bug/git-bug";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      royneary
      DeeUnderscore
      sudoforge
    ];
    mainProgram = "git-bug";
  };
}
