{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.50";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "1shrw7pxwrz9g5x9bq6k5qvhn3fqmwznadpw7i07msh97p8b3dyn";
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
