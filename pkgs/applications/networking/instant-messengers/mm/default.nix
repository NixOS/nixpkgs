{ stdenv, buildGoPackage, fetchFromGitLab }:

buildGoPackage rec {
  pname = "mm";
  version = "2016.11.04";

  goPackagePath = "gitlab.com/meutraa/mm";

  src = fetchFromGitLab {
    owner = "meutraa";
    repo = "mm";
    rev = "473fdd97285168054b672dbad2ffc4047324c518";
    sha256 = "1s8v5gxpw1sms1g3i8nq2x2mmmyz97qkmxs1fzlspfcd6i8vknkp";
  };

  meta = {
    description = "A file system based matrix client";
    homepage = https://gitlab.com/meutraa/mm;
    license = stdenv.lib.licenses.isc;
  };
}
