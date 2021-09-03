{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-bug";
  version = "0.7.2"; # the `rev` below pins the version of the source to get
  rev = "cc4a93c8ce931b1390c61035b888ad17110b7bd6";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "0r6wh0y1fj3d3fbbrzq5n9k6z94xvwqww3xfbslkgyrin5bmziiq";
  };

  vendorSha256 = "15hhsrwwjc4krfc2d0r15lys3vr9rb9xk62pan4jr9ycbv0dny90";

  doCheck = false;

  ldflags = [
    "-X github.com/MichaelMure/git-bug/commands.GitCommit=${rev}"
    "-X github.com/MichaelMure/git-bug/commands.GitLastTag=${version}"
    "-X github.com/MichaelMure/git-bug/commands.GitExactTag=${version}"
  ];

  postInstall = ''
    install -D -m 0644 misc/bash_completion/git-bug "$out/share/bash-completion/completions/git-bug"
    install -D -m 0644 misc/zsh_completion/git-bug "$out/share/zsh/site-functions/git-bug"
    install -D -m 0644 -t "$out/share/man/man1" doc/man/*
  '';

  meta = with lib; {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/MichaelMure/git-bug";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ royneary ];
  };
}
