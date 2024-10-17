{
  fetchurl,
  lib,
  mkDerivation,
  pkg-config,
  python3,
  file,
  bc,
  qtbase,
  qtsvg,
  hunspell,
  makeWrapper, # , mythes, boost
}:

mkDerivation rec {
  version = "2.4.2.1";
  pname = "lyx";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.4.x/${pname}-${version}.tar.xz";
    hash = "sha256-HSscer45Hi+0kQneLI4Tp9/mBfJ99o9om/lH36/HpNk=";
  };

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    python3
    qtbase
  ];
  buildInputs = [
    qtbase
    qtsvg
    file # for libmagic
    bc
    hunspell # enchant
  ];

  configureFlags = [
    "--enable-qt5"
    #"--without-included-boost"
    /*
      Boost is a huge dependency from which 1.4 MB of libs would be used.
       Using internal boost stuff only increases executable by around 0.2 MB.
    */
    #"--without-included-mythes" # such a small library isn't worth a separate package
  ];

  enableParallelBuilding = true;
  doCheck = true;

  # python is run during runtime to do various tasks
  qtWrapperArgs = [ " --prefix PATH : ${python3}/bin" ];

  meta = with lib; {
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = "http://www.lyx.org";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.vcunat ];
    platforms = platforms.linux;
  };
}
