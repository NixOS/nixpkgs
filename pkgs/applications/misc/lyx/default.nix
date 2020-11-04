{ fetchurl, lib, mkDerivation, pkgconfig, python, file, bc
, qtbase, qtsvg, hunspell, makeWrapper #, mythes, boost
}:

mkDerivation rec {
  version = "2.3.5.2";
  pname = "lyx";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.3.x/${pname}-${version}.tar.xz";
    sha256 = "1pwdh0ljd7lm5a83vsqmp4695irhig07wxa90jc23ng5gap589na";
  };

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    qtbase qtsvg python file/*for libmagic*/ bc
    hunspell makeWrapper # enchant
  ];

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
  qtWrapperArgs = [
    " --prefix PATH : ${python}/bin"
  ];

  meta = with lib; {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = "http://www.lyx.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.linux;
  };
}

