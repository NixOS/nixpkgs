{stdenv, fetchurl, x11, glib}:

assert !isNull x11 && !isNull glib;
assert x11.buildClientLibs;

derivation {
  name = "gtk+-1.2.10";
  system = stdenv.system;

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gtk/v1.2/gtk+-1.2.10.tar.gz;
    md5 = "4d5cb2fc7fb7830e4af9747a36bfce20";
  };

  stdenv = stdenv;
  x11 = x11;
  glib = glib;
}
