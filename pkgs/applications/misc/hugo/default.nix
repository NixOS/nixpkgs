{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.46";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "0w5xkb6s03hprb4v151gdk8zzsgvy0i406363j1w03bic8ajwgmj";
  };

  goDeps = ./deps.nix;

  buildFlags = "-tags extended";

  postInstall = ''
    rm $bin/bin/generate
  '';

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux ];
  };
}
