{ lib
, stdenv
, fetchurl
, xlibsWrapper
, makeWrapper
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
  version = "3.2.8a";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/xfig-${version}.tar.xz";
    sha256 = "0y45i1gqg3r0aq55jk047l1hnv90kqis6ld9lppx6c5jhpmc0hxs";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [
    xlibsWrapper
    libXpm
    libXmu
    libXi
    libXp
    Xaw3d
    libXaw
  ];

  postPatch = ''
    sed -i 's:"fig2dev":"${fig2dev}/bin/fig2dev":' src/main.c
  '';

  postInstall = ''
    mkdir -p $out/share/X11/app-defaults
    cp app-defaults/* $out/share/X11/app-defaults

    wrapProgram $out/bin/xfig \
      --set XAPPLRESDIR $out/share/X11/app-defaults
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
