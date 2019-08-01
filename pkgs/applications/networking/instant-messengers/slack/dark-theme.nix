{ stdenv, fetchurl }:

let
  rev = "e2a6a9cd9da70175881ab991220c86aa87179509";
  sha256 = "1gw0kpszgflk3vqjlm5igd2rznh36mb2j1iqrcqi6pzxlpccv1lg";
  version = "2019-07-25";
in stdenv.mkDerivation {
  inherit version;

  name = "slack-theme-black";
  src = fetchurl {
    url = "https://raw.githubusercontent.com/laCour/slack-night-mode/${rev}/css/raw/black.css";
    inherit sha256;
  };

  dontUnpack = true;

  buildCommand = ''
    mkdir $out
    cp $src $out/theme.css
  '';
}
