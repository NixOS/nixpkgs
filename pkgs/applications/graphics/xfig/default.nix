{ lib
, stdenv
, fetchurl
, makeWrapper
, imagemagick
, libXpm
, libXmu
, libXi
, libXp
, Xaw3d
, libXaw
, fig2dev
}:

stdenv.mkDerivation rec {
  pname = "xfig";
  version = "3.2.8b";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/xfig-${version}.tar.xz";
    sha256 = "0fndgbm1mkqb1sn2v2kj3nx9mxj70jbp31y2bjvzcmmkry0q3k5j";
  };

  nativeBuildInputs = [ imagemagick makeWrapper ];

  buildInputs = [
    libXpm
    libXmu
    libXi
    libXp
    Xaw3d
    libXaw
  ];

  postPatch = ''
    substituteInPlace src/main.c --replace '"fig2dev"' '"${fig2dev}/bin/fig2dev"'
    substituteInPlace xfig.desktop --replace "/usr/bin/" "$out/bin/"
  '';

  postInstall = ''
    mkdir -p $out/share/X11/app-defaults
    cp app-defaults/* $out/share/X11/app-defaults

    wrapProgram $out/bin/xfig \
      --set XAPPLRESDIR $out/share/X11/app-defaults

    mkdir -p $out/share/icons/hicolor/{16x16,22x22,48x48,64x64}/apps

    for dimension in 16x16 22x22 48x48; do
      convert doc/html/images/xfig-logo.png -geometry $dimension\
        $out/share/icons/hicolor/16x16/apps/xfig.png
    done
    install doc/html/images/xfig-logo.png \
      $out/share/icons/hicolor/64x64/apps/xfig.png
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An interactive drawing tool for X11";
    longDescription = ''
      Note that you need to have the <literal>netpbm</literal> tools
      in your path to export bitmaps.
    '';
    inherit (fig2dev.meta) license homepage platforms maintainers;
  };
}
