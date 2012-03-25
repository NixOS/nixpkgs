{stdenv, fetchhg, xproto, libX11, patches ? []}:

stdenv.mkDerivation rec {
  name = "tabbed-20120209";
 
  src = fetchhg {
    url = http://hg.suckless.org/tabbed;
    tag = "d7542a6f6dc5";
    sha256 = "1963jsazfmh5k7923c1mfwppz1xbh48z16j0sa64fiscq22as2gj";
  };

  # Allow users set their own list of patches
  inherit patches;

  buildInputs = [ xproto libX11 ];

  preInstall = ''
    export makeFlags="PREFIX=$out"
  '';
 
  meta = {
    homepage = http://tools.suckless.org/tabbed;
    description = "Simple generic tabbed fronted to xembed aware applications";
    license="MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
