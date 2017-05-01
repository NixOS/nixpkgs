{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.20.6";

  goPackagePath = "github.com/spf13/hugo";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "1r8sjx7rbrjk2a3x3x6cd987xykm2j06jbnwxxsn4rs6yym0yjl8";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
