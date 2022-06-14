{ fetchurl }:
rec {
  crystfel-pname = "crystfel";
  crystfel-version = "0.10.1";

  crystfel-src = fetchurl {
    url = "https://www.desy.de/~twhite/${crystfel-pname}/${crystfel-pname}-${crystfel-version}.tar.gz";
    sha256 = "0i9d5ggalic7alj97dxjdys7010kxhm2cb4lwakvigl023j8ms79";
  };
}
