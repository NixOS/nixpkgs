{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-bug";
  version = "0.8.0"; # the `rev` below pins the version of the source to get
  rev = "v0.8.0";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "12byf6nsamwz0ssigan1z299s01cyh8bhgj86bibl90agd4zs9n8";
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

    # not sure why the following executables are in $out/bin/
    rm -f $out/bin/cmd
    rm -f $out/bin/completion
    rm -f $out/bin/doc
  '';

  meta = with lib; {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/MichaelMure/git-bug";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ royneary ];
  };
}
