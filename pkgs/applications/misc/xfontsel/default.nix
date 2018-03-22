# This program used to come with xorg releases, but now I could only find it
# at https://www.x.org/releases/individual/.
# That is why this expression is not inside pkgs.xorg

{stdenv, fetchurl, makeWrapper, libX11, pkgconfig, libXaw}:
stdenv.mkDerivation rec {
  name = "xfontsel-1.0.6";

  src = fetchurl {
    url = "mirror://xorg/individual/app/${name}.tar.bz2";
    sha256 = "0700lf6hx7dg88wq1yll7zjvf9gbwh06xff20yffkxb289y0pai5";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [libX11 makeWrapper libXaw];

  # Without this, it gets Xmu as a dependency, but without rpath entry
  NIX_LDFLAGS = "-lXmu";

  # This will not make xfontsel find its app-defaults, but at least the $out
  # directory will contain them.
  # hack: Copying the XFontSel app-defaults file to $HOME makes xfontsel work.
  installPhase = ''
    make install appdefaultdir=$out/share/X11/app-defaults
    wrapProgram $out/bin/xfontsel \
      --set XAPPLRESDIR $out/share/X11/app-defaults
  '';

  meta = {
    homepage = https://www.x.org/;
    description = "Allows testing the fonts available in an X server";
    license = stdenv.lib.licenses.free;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
