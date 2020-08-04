{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-bug";
  version = "0.7.1"; # the `rev` below pins the version of the source to get
  rev = "2d64b85db71a17ff3277bbbf7ac9d8e81f8e416c";
  goPackagePath = "github.com/MichaelMure/git-bug";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "01ab3mlwh5g1vr3x85fppflg18gb8ip9mjfsp2b5rfigd9lxyyns";
  };

  vendorSha256 = "0c8b47lj4wl3s21lm0vx4z7hznylm8c4fb8b8gxm278kn3zys607";

  buildFlagsArray = ''
    -ldflags=
      -X ${goPackagePath}/commands.GitCommit=${rev}
      -X ${goPackagePath}/commands.GitLastTag=${version}
      -X ${goPackagePath}/commands.GitExactTag=${version}
  '';

  postInstall = ''
    install -D -m 0644 misc/bash_completion/git-bug "$out/etc/bash_completion.d/git-bug"
    install -D -m 0644 misc/zsh_completion/git-bug "$out/share/zsh/site-functions/git-bug"
    install -D -m 0644 -t "$out/share/man/man1" doc/man/*
  '';

  meta = with stdenv.lib; {
    description = "Distributed bug tracker embedded in Git";
    homepage = "https://github.com/MichaelMure/git-bug";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ royneary ];
  };
}
