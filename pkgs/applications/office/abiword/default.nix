{ lib, stdenv, fetchurl, pkg-config, gtk3, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2, libjpeg, perl
, boost, libxslt, goffice, wrapGAppsHook, gnome
}:

stdenv.mkDerivation rec {
  pname = "abiword";
  version = "3.0.4";

  src = fetchurl {
    url = "https://www.abisource.com/downloads/abiword/${version}/source/${pname}-${version}.tar.gz";
    sha256 = "1mx5l716n0z5788i19qmad30cck4v9ggr071cafw2nrf375rcc79";
  };

  enableParallelBuilding = true;

  patches = [
    # Switch to using enchant2; note by the next update enchant2 should be
    # default and this patch can be removed.
    # https://github.com/NixOS/nixpkgs/issues/38506
    (fetchurl {
      url = "https://raw.githubusercontent.com/archlinux/svntogit-packages/d3ff951d3c7249927e7113b3de1653031db24596/abiword/trunk/enchant-2.1.patch";
      sha256 = "444dc2aadea3c80310a509b690097541573f6d2652c573d04da66a0f385fcfb2";
    })
  ];

  postPatch = ''
    substituteInPlace configure --replace 'enchant >=' 'enchant-2 >='
  '';

  nativeBuildInputs = [ pkg-config wrapGAppsHook ];

  buildInputs = [
    gtk3 librsvg bzip2 fribidi libpng popt
    libgsf enchant wv libjpeg perl boost libxslt goffice gnome.adwaita-icon-theme
  ];

  meta = with lib; {
    description = "Word processing program, similar to Microsoft Word";
    homepage = "https://www.abisource.com/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ylwghst sna ];
  };
}
