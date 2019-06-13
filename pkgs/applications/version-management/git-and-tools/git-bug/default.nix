{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-bug-${version}";
  version = "0.5.0";
  rev = "8d7a2c076a38c89085fd3191a2998efb659650c2";
  goPackagePath = "github.com/MichaelMure/git-bug";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "1l86m0y360lmpmpw2id0k7zc2nyq1irr26k2ik06lxhzvpbyajz6";
  };

  buildFlagsArray = ''
    -ldflags= 
      -X ${goPackagePath}/commands.GitCommit=${rev}
      -X ${goPackagePath}/commands.GitLastTag=${version}
      -X ${goPackagePath}/commands.GitExactTag=${version}
  '';

  postInstall = ''
    cd go/src/${goPackagePath}
    install -D -m 0644 misc/bash_completion/git-bug "$bin/etc/bash_completion.d/git-bug"
    install -D -m 0644 misc/zsh_completion/git-bug "$bin/share/zsh/site-functions/git-bug"
    install -D -m 0644 -t "$bin/share/man/man1" doc/man/*
  '';

  meta = with stdenv.lib; {
    description = "Distributed bug tracker embedded in Git";
    homepage = https://github.com/MichaelMure/git-bug;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ royneary ];
  };
}
