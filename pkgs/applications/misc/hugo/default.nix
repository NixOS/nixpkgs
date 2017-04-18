{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.20.2";

  goPackagePath = "github.com/spf13/hugo";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "1dvd9kiqp87cbf027kvyqb282pxs8qm16r1dk74l5drranfvkszy";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
