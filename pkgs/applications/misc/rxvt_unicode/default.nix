{ stdenv, fetchurl, perlSupport, libX11, libXt, libXft, ncurses, perl,
  fontconfig, freetype, pkgconfig, libXrender }:

let 
  name = "rxvt-unicode";
  version = "9.16";
  n = "${name}-${version}";
in

stdenv.mkDerivation (rec {

  name = "${n}${if perlSupport then "-with-perl" else ""}";

  src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${version}.tar.bz2";
    sha256 = "0x28wyslqnhn2q11y4hncqdl07wgh5ypywl92fq0jxycr36ibfvn";
  };

  buildInputs =
    [ libX11 libXt libXft ncurses /* required to build the terminfo file */ 
      fontconfig freetype pkgconfig libXrender ]
    ++ stdenv.lib.optional perlSupport perl;

  preConfigure =
    ''
      configureFlags="--with-terminfo=$out/share/terminfo ${if perlSupport then "--enable-perl" else "--disable-perl"}";
      export TERMINFO=$out/share/terminfo # without this the terminfo won't be compiled by tic, see man tic
      NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
      NIX_LDFLAGS="$NIX_LDFLAGS -lfontconfig -lXrender "
    ''
    # make urxvt find its perl file lib/perl5/site_perl is added to PERL5LIB automatically
    + stdenv.lib.optionalString perlSupport ''
      mkdir -p $out/lib/perl5
      ln -s $out/{lib/urxvt,lib/perl5/site_perl}
    '';

  meta = {
    description = "A clone of the well-known terminal emulator rxvt";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
  };
})
