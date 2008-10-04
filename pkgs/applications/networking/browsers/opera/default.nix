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
        url = http://snapshot.opera.com/unix/snapshot-1754/x86_64-linux/opera-9.50-20080110.2-shared-qt.x86_64-1754.tar.bz2;
        sha256 = "08y1ajjncdvbhvcq2izmpgc4fi37bwn43zsw7rz41jf8qhvb5ywv";
        #url = ftp://ftp.task.gda.pl/pub/opera/linux/950b/final/en/x86_64/opera-9.50-20071024.2-shared-qt.x86_64-1643.tar.bz2;
        #sha256 = "1gv1r18ar3vz1l24nf8qixjlba1yb5d3xvg3by41i4dy0vlznqn6";
        #name = opera-9.25-20071214.6-shared-qt.i386-en.tar.gz;
        #url = http://www.opera.com/download/get.pl?id=30462&location=225&nothanks=yes&sub=marine;
        #sha256 = "1wnc1s4r5gz73mxs8pgsi9a1msz7x8a8pb1ykb1xgdfn21h69p2p";
      } else throw "unsupported platform ${stdenv.system} (only i686-linux and x86_64 linux supported yet)";

  dontStrip = 1;
  # operapluginwrapper seems to require libXt ?
  # Adding it makes startup faster and omits error messages (on x68)
  libPath =
    [glibc qt motif zlib libX11 libXt libXext libSM libICE libstdcpp5]
    ++ (if motif != null then [motif ] else []);

  meta = {
    homepage = http://www.opera.com;
  };
}
