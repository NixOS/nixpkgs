{stdenv, fetchurl, pkgconfig, x11, fontconfig}:

assert !isNull pkgconfig && !isNull x11 && !isNull fontconfig;
assert fontconfig.x11 == x11;

derivation {
  name = "xft-2.1.2";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://pdx.freedesktop.org/software/fontconfig/releases/xft-2.1.2.tar.gz;
    md5 = "defb7e801d4938b8b15a426ae57e2f3f";
  };
  stdenv = stdenv;
  pkgconfig = pkgconfig;
  x11 = x11;
  fontconfig = fontconfig;
}
