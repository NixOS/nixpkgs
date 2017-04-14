{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.20";

  goPackagePath = "github.com/spf13/hugo";

  src = fetchFromGitHub {
    owner = "spf13";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "1dzvwldhf73ycmazq9xnridj7p3m3q6qv47rvk3vgj0xj6c107ij";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
