{
  lib,
  fetchFromGitHub,
  fetchurl,
  python3Packages,
  readline,
  ncurses,
  canto-daemon,
}:

python3Packages.buildPythonApplication rec {
  version = "0.9.9";
  format = "setuptools";
  pname = "canto-curses";

  src = fetchFromGitHub {
    owner = "themoken";
    repo = "canto-curses";
    rev = "v${version}";
    sha256 = "1vzb9n1j4gxigzll6654ln79lzbrrm6yy0lyazd9kldyl349b8sr";
  };

  # Fixes the issue found here https://github.com/themoken/canto-curses/issues/59
  patches = [
    (fetchurl {
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/canto-curses/-/raw/6daa56bc5baebb2444c368a8208666ef484a6fc0/fix-build.patch";
      hash = "sha256-2TMNmwjUAGyenSDqxfI+U2hNeDZaj2CivfTfpX7CKgY=";
    })
  ];

  buildInputs = [
    readline
    ncurses
    canto-daemon
  ];
  propagatedBuildInputs = [ canto-daemon ];

  meta = {
    description = "Ncurses-based console Atom/RSS feed reader";
    mainProgram = "canto-curses";
    longDescription = ''
      Canto is an Atom/RSS feed reader for the console that is meant to be
      quick, concise, and colorful. It's meant to allow you to crank through
      feeds like you've never cranked before by providing a minimal, yet
      information packed interface. No navigating menus. No dense blocks of
      unreadable white text. An interface with almost infinite customization
      and extensibility using the excellent Python programming language.
    '';
    homepage = "https://codezen.org/canto-ng/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.devhell ];
  };
}
