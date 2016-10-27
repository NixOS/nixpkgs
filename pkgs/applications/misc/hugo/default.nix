{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.17";

  goPackagePath = "github.com/spf13/hugo";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "1h5d7m019r4zhk7xlcdbn4z3w6x7jq2lcdgq7w377688rk58wbgp";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
