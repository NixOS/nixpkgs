{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libstdcpp5, glibc
, motif ? null, libXt ? null}:

assert motif != null -> libXt != null;

# !!! Add Xinerama and Xrandr dependencies?  Or should those be in Qt?

# Hm, does Opera 9.x still use Motif for anything?

stdenv.mkDerivation rec {
  version = "9.24-20071015.5";
  name = "opera-${version}";

  inherit libstdcpp5;

  builder = ./builder.sh;
    src = if (stdenv.system == "i686-linux") then
      fetchurl {
        url = ftp://ftp.task.gda.pl/pub/opera/linux/950b/final/en/i386/shared/opera-9.50b-20071024.5-shared-qt.i386-en.tar.bz2;
        sha256 = "0vv1q86is9x6vw8fx92wrnvlyn4x29zgk9zjn66rcx37n6grqqah";
      } else if (stdenv.system == "x86_64-linux") then
      fetchurl {
        url = ftp://ftp.task.gda.pl/pub/opera/linux/950b/final/en/x86_64/opera-9.50-20071024.2-shared-qt.x86_64-1643.tar.bz2;
        sha256 = "1gv1r18ar3vz1l24nf8qixjlba1yb5d3xvg3by41i4dy0vlznqn6";
      } else throw "unsupported platform ${stdenv.system} (only i686-linux and x86_64 linux supported yet)";

  # operapluginwrapper seems to require libXt ?
  # Adding it makes startup faster and omits error messages (on x68)
  libPath =
    [glibc qt motif zlib libX11 libXt libXext libSM libICE libstdcpp5]
    ++ (if motif != null then [motif ] else []);
}
