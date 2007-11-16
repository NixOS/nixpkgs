args: with args;

stdenv.mkDerivation rec {
  name = "gphoto2-2.4.0";
  src = fetchurl {
    url = "mirror://sourceforge/gphoto/${name}.tar.bz2";
    sha256 = "1rf4w5m35dsi8dkwwnh4wg70xivdi9j79f2dy3rq90p1v8sar9ca";
  };
  buildInputs = [pkgconfig libgphoto2 libexif popt gettext];
# There is a bug in 2.4.0 configure.ac (in their m4 macroses)
  patchPhase = "sed -e 's@_tmp=true@_tmp=false@' -i configure configure.ac";
}
