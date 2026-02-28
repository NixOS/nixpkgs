{
  lib,
  stdenv,
  fetchFromGitHub,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "urxvt-tabbedex";
  version = "26.09";

  src = fetchFromGitHub {
    owner = "mina86";
    repo = "urxvt-tabbedex";
    rev = "v${version}";
    sha256 = "sha256-rTlYxB3IdmWslu3GMyAoaHV2ErapOVB9jhSWiYqVwJ0=";
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
