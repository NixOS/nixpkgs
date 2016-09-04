{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "v0.16";
  rev = "8b54843a0db694facbaf368af4e777d0ae5fb992";

  goPackagePath = "github.com/spf13/hugo";

  src = fetchFromGitHub {
    inherit rev;
    owner = "spf13";
    repo = "hugo";
    sha256 = "135mrdi8i56z9m2sihjrdfab6lrczbfgavwvfrngvi1zxnx7scmv";
  };

  goDeps = ./deps.json;
}
