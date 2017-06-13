{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.22.1";

  goPackagePath = "github.com/spf13/hugo";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "0m459np11izsflwdja6k0znaxvd8zpgivvswnq9501m49h8m4x7q";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
