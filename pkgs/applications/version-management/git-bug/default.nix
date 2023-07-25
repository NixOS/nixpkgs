{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "git-bug";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "MichaelMure";
    repo = "git-bug";
    rev = "v${version}";
    sha256 = "12byf6nsamwz0ssigan1z299s01cyh8bhgj86bibl90agd4zs9n8";
  };

  vendorSha256 = "sha256-32kNDoBE50Jx1Ef9YwhDk7nd3CaTSnHPlu7PgWPUGfE=";

  nativeBuildInputs = [ installShellFiles ];

  doCheck = false;

  excludedPackages = [ "doc" "misc" ];

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
    homepage = "https://github.com/MichaelMure/git-bug";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ royneary DeeUnderscore ];
  };
}
