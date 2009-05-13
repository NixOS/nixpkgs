{ stdenv, fetchurl, qt, zlib, libX11, libXext, libSM, libICE, libstdcpp5, glibc
, motif ? null, libXt ? null
, makeDesktopItem
}:

assert motif != null -> libXt != null;

# !!! Add Xinerama and Xrandr dependencies?  Or should those be in Qt?

# Hm, does Opera 9.x still use Motif for anything?

stdenv.mkDerivation rec {
  version = "9.64";
  name = "opera-${version}";

  inherit libstdcpp5;

  builder = ./builder.sh;
    src = if (stdenv.system == "i686-linux") then
      fetchurl {
	url = ftp://mirror.liteserver.nl/pub/opera/linux/964/final/en/i386/static/opera-9.64.gcc295-static-qt3.i386.tar.gz;
        sha256 = "0ryza8wrqhlcs9hs3vs38ig3pjwifymxi8jsx83kvxg963p2k825";
      } else if (stdenv.system == "x86_64-linux") then
      fetchurl {
        url = http://mirror.liteserver.nl/pub/opera/linux/964/final/en/x86_64/opera-9.64.gcc4-shared-qt3.x86_64.tar.gz ;
        sha256 = "1zmj8lr1mx3d98adyd93kw2ldxxb13wzi6xzlgmb3dr4pn9j85n2";
      } else throw "unsupported platform ${stdenv.system} (only i686-linux and x86_64 linux supported yet)";

  dontStrip = 1;
  # operapluginwrapper seems to require libXt ?
  # Adding it makes startup faster and omits error messages (on x68)
  libPath =
    [glibc qt motif zlib libX11 libXt libXext libSM libICE libstdcpp5]
    ++ (if motif != null then [motif ] else []);

  desktopItem = makeDesktopItem {
    name = "Opera";
    exec = "opera";
    icon = "opera";
    comment = "Opera Web Browser";
    desktopName = "Opera";
    genericName = "Web Browser";
    categories = "Application;Network;";
  };


  meta = {
    homepage = http://www.opera.com;
  };
}
