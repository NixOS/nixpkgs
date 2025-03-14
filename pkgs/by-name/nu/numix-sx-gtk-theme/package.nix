{
  lib,
  stdenv,
  fetchurl,
  gtk-engine-murrine,
}:

stdenv.mkDerivation {
  version = "2017-04-24";
  pname = "numix-sx-gtk-theme";

  src = fetchurl {
    url = "https://dl.opendesktop.org/api/files/download/id/1493077417/Numix-SX.tar.xz";
    sha256 = "7e1983924b2d90e89eddb3da8f4c43dc1326fe138fd191c8212c7904dcd618b0";
  };

  propagatedUserEnvPkgs = [ gtk-engine-murrine ];

  dontBuild = true;

  sourceRoot = ".";

  installPhase = ''
    install -dm 755 "$out/share/themes/"
    cp -dr --no-preserve='ownership' Numix-SX-{Dark,FullDark,Light} "$out/share/themes/"
  '';

  meta = {
    description = "Gray variation of Numix theme";
    homepage = "https://www.gnome-look.org/p/1117412/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.sauyon ];
  };
}
