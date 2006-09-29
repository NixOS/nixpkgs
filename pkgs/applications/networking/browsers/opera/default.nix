{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libstdcpp5
, motif ? null, libXt ? null}:

assert stdenv.system == "i686-linux";
assert motif != null -> libXt != null;

# !!! Add Xinerama and Xrandr dependencies?  Or should those be in Qt?

# Hm, does Opera 9.x still use Motif for anything?

stdenv.mkDerivation {
  name = "opera-9.02-20060919.5";

  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.tiscali.nl/pub/mirrors/opera/linux/902/final/en/i386/shared/opera-9.02-20060919.5-shared-qt.i386-en.tar.bz2;
    md5 = "327d0bf1f3c4eedd47b444b36c9091f6";
  };

  libPath =
    [qt motif zlib libX11 libXext libSM libICE libstdcpp5]
    ++ (if motif != null then [motif libXt ] else []);
}
