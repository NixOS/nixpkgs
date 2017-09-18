{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "hugo-${version}";
  version = "0.27.1";

  goPackagePath = "github.com/gohugoio/hugo";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    rev = "v${version}";
    sha256 = "0vxzjwm9dsan314cz0gnj4spssg4w8y6ywsak8n9c6w0l45xf07p";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "A fast and modern static website engine.";
    homepage = https://gohugo.io;
    maintainers = with stdenv.lib.maintainers; [ schneefux ];
    license = stdenv.lib.licenses.asl20;
  };
}
