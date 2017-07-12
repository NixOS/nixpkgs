{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.25";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "01p063nsyhavf13cva3sdqdcc7s42gi7iry4v857f1c2i402f0zk";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
