{
  fetchurl,
  lib,
  stdenv,
  pkg-config,
  python3,
  file,
  bc,
  libsForQt5,
  hunspell,
  makeWrapper, # , mythes, boost
}:

stdenv.mkDerivation rec {
  version = "2.5.1";
  pname = "lyx";

  src = fetchurl {
    url = "ftp://ftp.lyx.org/pub/lyx/stable/2.5.x/lyx-${version}.tar.xz";
    hash = "sha256-8qI4e8s/L1RsH8E+THTLT4qmSHBs5XiO9wXdUTRNLP0=";
  };

  # LaTeX is used from $PATH, as people often want to have it with extra pkgs
  nativeBuildInputs = [
    pkg-config
    makeWrapper
    python3
    libsForQt5.qtbase
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
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

  meta = {
    changelog = "https://www.lyx.org/announce/${lib.replaceString "." "_" version}.txt";
    description = "WYSIWYM frontend for LaTeX, DocBook";
    homepage = "https://www.lyx.org";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.vcunat ];
    platforms = lib.platforms.linux;
  };
}
