{ stdenv, fetchurl }:

let
  rev = "5cdbb97898d727d2b35c25a3117e9a79e474d97b";
  sha256 = "14qikp91l2aj8j9i0nh0nf9ibz65b8bpd3lbyarqshhrpvb5jp79";
  version = "2019-06-04";
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
