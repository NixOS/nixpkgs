{ stdenv, fetchurl, perlSupport, libX11, libXt, libXft, ncurses, perl,
  fontconfig, freetype, pkgconfig, libXrender, gdkPixbufSupport, gdk_pixbuf,
  unicode3Support }:

let
  name = "rxvt-unicode";
  version = "9.21";
  n = "${name}-${version}";
in

stdenv.mkDerivation (rec {

  name = "${n}${if perlSupport then "-with-perl" else ""}${if unicode3Support then "-with-unicode3" else ""}";

  src = fetchurl {
    url = "http://dist.schmorp.de/rxvt-unicode/Attic/rxvt-unicode-${version}.tar.bz2";
    sha256 = "0swmi308v5yxsddrdhvi4cch88k2bbs2nffpl5j5m2f55gbhw9vm";
  };

  buildInputs =
    [ libX11 libXt libXft ncurses /* required to build the terminfo file */
      fontconfig freetype pkgconfig libXrender ]
    ++ stdenv.lib.optional perlSupport perl
    ++ stdenv.lib.optional gdkPixbufSupport gdk_pixbuf;

  outputs = [ "out" "terminfo" ];

  patches = [
    ./rxvt-unicode-9.06-font-width.patch
    ./rxvt-unicode-256-color-resources.patch
  ]
  ++ stdenv.lib.optional stdenv.isDarwin ./rxvt-unicode-makefile-phony.patch;

  preConfigure =
    ''
      mkdir -p $terminfo/share/terminfo
      configureFlags="--with-terminfo=$terminfo/share/terminfo --enable-256-color ${if perlSupport then "--enable-perl" else "--disable-perl"} ${if unicode3Support then "--enable-unicode3" else "--disable-unicode3"}";
      export TERMINFO=$terminfo/share/terminfo # without this the terminfo won't be compiled by tic, see man tic
      NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${freetype}/include/freetype2"
      NIX_LDFLAGS="$NIX_LDFLAGS -lfontconfig -lXrender "
    ''
    # make urxvt find its perl file lib/perl5/site_perl is added to PERL5LIB automatically
    + stdenv.lib.optionalString perlSupport ''
      mkdir -p $out/lib/perl5
      ln -s $out/{lib/urxvt,lib/perl5/site_perl}
    '';

  postInstall = ''
    mkdir -p $out/nix-support
    echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
  '';

  meta = {
    description = "A clone of the well-known terminal emulator rxvt";
    homepage = "http://software.schmorp.de/pkg/rxvt-unicode.html";
    maintainers = [ stdenv.lib.maintainers.mornfall ];
  };
})
