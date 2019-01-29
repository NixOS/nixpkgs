{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "git-bug-${version}";
  version = "0.4.0";
  rev = "2ab2412771d58a1b1f3bfeb5a6e9da2e683b0e12";
  goPackagePath = "github.com/MichaelMure/git-bug";

  src = fetchFromGitHub {
    inherit rev;
    owner = "MichaelMure";
    repo = "git-bug";
    sha256 = "1zyvyg0p5h71wvyxrzkr1bwddxm3x8p44n6wh9ccfdxp8d2k6k25";
  };

  goDeps = ./deps.nix;

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
