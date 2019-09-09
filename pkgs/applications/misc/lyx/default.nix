{ fetchurl, stdenv, pkgconfig, python, file, bc, fetchpatch
, qtbase, qtsvg, hunspell, makeWrapper #, mythes, boost
}:

stdenv.mkDerivation rec {
  version = "2.3.0";
  pname = "lyx";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.3.x/${pname}-${version}.tar.xz";
    sha256 = "0axri2h8xkna4mkfchfyyysbjl7s486vx80p5hzj9zgsvdm5a3ri";
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
  postFixup = ''
    wrapProgram "$out/bin/lyx" \
      --prefix PATH : '${python}/bin'
  '';

  patches = [
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/app-office/lyx/files/lyx-2.3.0-qt-5.11.patch?id=07e82fd1fc07bf055c78b81eaa128f8f837da80d";
      sha256 = "1bnx0il2iv36lnrnyb370wyvww0rd8bphcy6z8d7zmvd3pwhyfql";
    })
  ];

  meta = with stdenv.lib; {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = http://www.lyx.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.linux;
  };
}

