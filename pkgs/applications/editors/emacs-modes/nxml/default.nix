{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "nxml-mode-20041004";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/nxml-mode-20041004.tar.gz;
    md5 = "ac137024cf337d6f11d8ab278d39b4db";
  };
}
