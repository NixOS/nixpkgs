{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-bug";
  version = "0.8.0"; # the `rev` below pins the version of the source to get
  rev = "a3fa445a9c76631c4cd16f93e1c1c68a954adef7";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "sha256-yCb9SXsKJLriMkg+uBD0LACdkvjBqhe1Bp9Xpa1xfok=";
  };

  vendorSha256 = "sha256-32kNDoBE50Jx1Ef9YwhDk7nd3CaTSnHPlu7PgWPUGfE=";

  doCheck = false;

  ldflags = [
    "-X github.com/MichaelMure/git-bug/commands.GitCommit=${rev}"
    "-X github.com/MichaelMure/git-bug/commands.GitLastTag=${version}"
    "-X github.com/MichaelMure/git-bug/commands.GitExactTag=${version}"
  ];

  postInstall = ''
    install -D -m 0644 misc/completion/bash/git-bug "$out/share/bash-completion/completions/git-bug"
    install -D -m 0644 misc/completion/zsh/git-bug "$out/share/zsh/site-functions/git-bug"
    install -D -m 0644 -t "$out/share/man/man1" doc/man/*
  '';

  meta = with lib; {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/MichaelMure/git-bug";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ royneary ];
  };
}
