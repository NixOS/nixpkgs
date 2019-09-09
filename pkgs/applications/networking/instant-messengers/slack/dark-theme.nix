{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  rev = "779bf26f7d9754879fbc1e308fc35ee154fd4b97";
  version = "2019-09-07";
  pname = "slack-theme-black";

  src = fetchgit { inherit rev;
    url = "https://github.com/laCour/slack-night-mode";
    sha256 = "0p3wjwwchb0zw10rf5qlx7ffxryb42hixfrji36c57g1853qhw0f";
  };

  dontUnpack = true;

  buildCommand = ''
    mkdir $out
    cp $src/css/raw/black.css $out/theme.css
  '';
}
