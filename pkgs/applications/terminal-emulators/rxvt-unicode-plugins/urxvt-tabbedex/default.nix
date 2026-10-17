{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-tabbedex";
  version = "26.16.1";

  src = fetchFromGitHub {
    owner = "mina86";
    repo = "urxvt-tabbedex";
    rev = "v${version}";
    sha256 = "sha256-e/t7AnP7nXkkazK6Oe6mw2Adf5wxR31/nFKeSaCpy/4";
  };

  nativeBuildInputs = [ perl ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "Tabbed plugin for rxvt-unicode with many enhancements (mina86's fork)";
    homepage = "https://github.com/mina86/urxvt-tabbedex";
    maintainers = [ ];
    platforms = with lib.platforms; unix;
    license = lib.licenses.gpl3Plus;
  };
}
