{ fetchurl, stdenv, pkgconfig, python, file, bc
, qtbase, qtsvg, hunspell, makeWrapper #, mythes, boost
}:

stdenv.mkDerivation rec {
  version = "2.2.3";
  name = "lyx-${version}";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.2.x/${name}.tar.xz";
    sha256 = "0mrbr24xbdg25gd7w8g76gpmy0a10nrnz0mz47mdjwi441yfpjjg";
  };

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    qtbase qtsvg python file/*for libmagic*/ bc
    hunspell makeWrapper # enchant
  ];

  # bogus configure script tests
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" $(pkg-config --cflags Qt5Core)"
  '';

  configureFlags = [
    "--enable-qt5"
    #"--without-included-boost"
    /*  Boost is a huge dependency from which 1.4 MB of libs would be used.
        Using internal boost stuff only increases executable by around 0.2 MB. */
    #"--without-included-mythes" # such a small library isn't worth a separate package
  ];

  enableParallelBuilding = true;
  doCheck = true;

  # python is run during runtime to do various tasks
  postFixup = ''
    wrapProgram "$out/bin/lyx" \
      --prefix PATH : '${python}/bin'
  '';

  meta = with stdenv.lib; {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = http://www.lyx.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.linux;
  };
}

