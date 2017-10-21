{ stdenv, fetchurl, pkgconfig, makeDesktopItem, unzip
, qtbase, qttools, qtmultimedia, qtquick1, qtquickcontrols
, openssl, protobuf, qmake
}:

stdenv.mkDerivation rec {
  name = "ricochet-${version}";
  version = "1.1.4";

  src = fetchurl {
    url = "https://github.com/ricochet-im/ricochet/archive/v${version}.tar.gz";
    sha256 = "1kfj42ksvj7axc809lb8siqzj5hck2pib427b63a3ipnqc5h1faf";
  };

  desktopItem = makeDesktopItem {
    name = "ricochet";
    exec = "ricochet";
    icon = "ricochet";
    desktopName = "Ricochet";
    genericName = "Ricochet";
    comment = meta.description;
    categories = "Office;Email;";
  };

  buildInputs = [
    qtbase qttools qtmultimedia qtquick1 qtquickcontrols
    openssl protobuf
  ];

  nativeBuildInputs = [ pkgconfig qmake ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags openssl)"
  '';

  qmakeFlags = [ "DEFINES+=RICOCHET_NO_PORTABLE" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ricochet $out/bin

    mkdir -p $out/share/applications
    cp $desktopItem/share/applications"/"* $out/share/applications

    mkdir -p $out/share/pixmaps
    cp icons/ricochet.png $out/share/pixmaps/ricochet.png
  '';

  meta = with stdenv.lib; {
    description = "Anonymous peer-to-peer instant messaging";
    homepage = https://ricochet.im;
    license = licenses.bsd3;
    maintainers = [ maintainers.codsl maintainers.jgillich maintainers.np ];
    platforms = platforms.linux;
  };
}
