{ stdenv, fetchgit }:

stdenv.mkDerivation rec {
  rev = "e2a6a9cd9da70175881ab991220c86aa87179509";
  version = "2019-07-26";
  pname = "slack-theme-black";

  src = fetchgit { inherit rev;
    url = "https://github.com/laCour/slack-night-mode";
    sha256 = "1jwxy63qzgvr83idsgcg7yhm9kn0ybfji1m964c5c6ypzcm7j10v";
  };

  dontUnpack = true;

  buildCommand = ''
    mkdir $out
    cp $src/css/raw/black.css $out/theme.css
  '';
}
