{
  stdenv,
  fetchFromGitHub,
  ncurses,
  bison,
  lib,
}:
stdenv.mkDerivation {
  pname = "sc";
  version = "2024-08-15";

  src = fetchFromGitHub {
    repo = "sc";
    owner = "n-t-roff";
    rev = "e029bc0fb5fa29da1fd23b04fa2a97039a96d2ba";
    hash = "sha256-JQY+ixHL+TpP4YRpgB9GP4jO5+PBMS/v5Ad3Ux0+yuQ=";
  };

  buildInputs = [ ncurses ];

  nativeBuildInputs = [ bison ];

  installFlags = [ "prefix=$(out)" ];

  # Non-standard configure script
  configurePhase = "./configure";

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Curses-based spreadsheet calculator.";

    longDescription = ''
      This is a fork of the old sc-7.16 application with attention paid to
      reduced compiler warnings, bugfixes, and functionality improvements
      (e.g. mouse suport, configurability via .scrc).
      See CHANGES-git or README.md for a full list of changes.
    '';

    homepage = "https://github.com/n-t-roff/sc";
    license = lib.licenses.unlicense;
    maintainers = [ lib.maintainers.claes ];
  };
}
