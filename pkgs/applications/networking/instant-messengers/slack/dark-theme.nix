{ stdenv, fetchurl }:

let
  rev = "56d2007b5ba9f1628a44af6edf5dbdf74cf92278";
  sha256 = "1v264mpf9ddiz8zb7fcyjwy1a2yr5f4xs520gf63kl9378v721da";
  version = "2019-03-15";
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
