{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  expat,
  ncurses,
  openssl,
}:

stdenv.mkDerivation {
  pname = "boinctui";
  version = "2.7.1-unstable-2023-12-14";

  src = fetchFromGitHub {
    owner = "suleman1971";
    repo = "boinctui";
    rev = "6656f288580170121f53d0e68c35077f5daa700b"; # no proper release tags unfortunaly
    hash = "sha256-MsSTvlTt54ukQXyVi8LiMFIkv8FQJOt0q30iDxf4TsE=";
  };

  # Fix wrong path; @docdir@ already gets replaced with the correct store path
  postPatch = ''
    substituteInPlace Makefile.in \
      --replace 'DOCDIR = $(DATAROOTDIR)@docdir@' 'DOCDIR = @docdir@'
  '';

  outputs = [
    "out"
    "man"
  ];
  separateDebugInfo = stdenv.hostPlatform.isLinux;

  enableParallelBuilding = true;

  configureFlags = [ "--without-gnutls" ];
  nativeBuildInputs = [ autoreconfHook ];
  buildInputs = [
    expat
    ncurses
    openssl
  ];

  meta = with lib; {
    description = "Curses based fullscreen BOINC manager";
    homepage = "https://github.com/suleman1971/boinctui";
    changelog = "https://github.com/suleman1971/boinctui/blob/master/changelog";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ christoph-heiss ];
    platforms = platforms.linux;
    mainProgram = "boinctui";
  };
}
