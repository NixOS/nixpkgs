{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libstdcpp5
, motif ? null, libXt ? null}:

assert stdenv.system == "i686-linux";
assert motif != null -> libXt != null;

# !!! Add Xinerama and Xrandr dependencies?  Or should those be in Qt?

# Hm, does Opera 9.x still use Motif for anything?

stdenv.mkDerivation rec {
  version = "9.24-20071015.5";
  name = "opera-${version}";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.task.gda.pl/pub/opera/linux/924/final/en/i386/shared/opera-9.24-20071015.5-shared-qt.i386-en.tar.bz2;
    sha256 = "1frhnrp63k4lz29a8z9c99h383xrsrby432xp20hxrylh0zypzb5";
  };

  libPath =
    [qt motif zlib libX11 libXext libSM libICE libstdcpp5]
    ++ (if motif != null then [motif libXt ] else []);
}
