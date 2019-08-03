{ stdenv, fetchurl, xlibsWrapper, makeWrapper, libXpm
, libXmu, libXi, libXp, Xaw3d, fig2dev
}:

let
  version = "3.2.7a";

in stdenv.mkDerivation {
  name = "xfig-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/mcj/xfig-${version}.tar.xz";
    sha256 = "096zgp0bqnxhgxbrv2jjylrjz3pr4da0xxznlk2z7ffxr5pri2fa";
  };

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

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ xlibsWrapper libXpm libXmu libXi libXp Xaw3d ];

  meta = with stdenv.lib; {
    description = "An interactive drawing tool for X11";
    longDescription = ''
      Note that you need to have the <literal>netpbm</literal> tools
      in your path to export bitmaps.
    '';
    inherit (fig2dev.meta) license homepage platforms;
  };
}
