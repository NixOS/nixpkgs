{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "git-bug";
  version = "0.7.0";
  rev = "71580c41a931a1ad2c04682e0fd701661b716c95";
  goPackagePath = "github.com/MichaelMure/git-bug";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "0mhqvcwa6y3hrrv88vbp22k7swzr8xw6ipm80gdpx85yp8j2wdkh";
  };

  modSha256 = "1cfn49cijiarzzczrpd28x1k7ib98xyzlvn3zghwk2ngfgiah3ld";

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
    homepage = https://github.com/MichaelMure/git-bug;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ royneary ];
  };
}
