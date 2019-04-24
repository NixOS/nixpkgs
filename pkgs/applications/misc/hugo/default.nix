{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "hugo-${version}";
  version = "0.55.3";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "0hpyaxfjgfm04fcw3qha2rdx93fr326mw5aiw95vnj5i0x1xbs3x";
  };

  modSha256 = "0yrwkaaasj9ihjjfbywnzkppix1y2znagg3dkyikk21sl5n0nz23";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux ];
  };
}
