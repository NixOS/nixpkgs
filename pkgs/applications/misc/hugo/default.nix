{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.29";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "1vklws05534ig9rj55cqnxpqfsvns64kfdg6zjyrcpz7l0z07a33";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
