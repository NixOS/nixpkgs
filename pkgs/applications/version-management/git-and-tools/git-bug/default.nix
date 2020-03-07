{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  pname = "git-bug";
  version = "0.6.0";
  rev = "fc568209f073b9d775a09e0dbb8289cf9e5749bf";
  goPackagePath = "github.com/MichaelMure/git-bug";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "1s18lzip52qpf52ad6m20j306mr16vnwhz9f7rirsa6b7srmcgli";
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
