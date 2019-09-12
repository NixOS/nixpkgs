{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  rev = "f760176c6e133667ce73aeecba8b0c0eb8822941";
  version = "2019-09-11";
  pname = "slack-theme-black";

  src = fetchgit { inherit rev;
    url = "https://github.com/laCour/slack-night-mode";
    sha256 = "1kx8nx7mhrabs5wxqgvy86s5smy5hw49gv6yc95yxwx6ymwpgbzj";
  };

  dontUnpack = true;

  buildCommand = ''
    mkdir $out
    cp $src/css/raw/black.css $out/theme.css
  '';
}
