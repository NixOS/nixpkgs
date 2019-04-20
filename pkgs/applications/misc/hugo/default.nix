{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "hugo-${version}";
  version = "0.55.2";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "0v06hn9wnq9bp4pdh3pzhkp6adpba6pxk9w42p0v2mpgsjdvm5j0";
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
