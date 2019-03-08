{ stdenv, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  name = "hugo-${version}";
  version = "0.54.0";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner  = "gohugoio";
    repo   = "hugo";
    rev    = "v${version}";
    sha256 = "01grfbr3kpd4qf5cbcmzc6yfq34cm0nkak4pqzgrn46r254y0ymv";
  };

  modSha256 = "0fqmxmhbzkd5617gch836l7clqbxx8b1mxx09v3v2c4jjxcm85cm";

  buildFlags = "-tags extended";

  subPackages = [ "." ];

  meta = with stdenv.lib; {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    license = licenses.asl20;
    maintainers = with maintainers; [ schneefux ];
  };
}
