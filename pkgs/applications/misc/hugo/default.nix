{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.47";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "1h62ix285mx977mgawyanyvsqqic1xx0gmi1r5wn43w9yc29wr0z";
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
