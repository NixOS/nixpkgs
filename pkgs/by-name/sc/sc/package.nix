{
  stdenv,
  fetchFromGitHub,
  ncurses,
  bison,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "sc";
  version = "7.16_1.1.4";

  src = fetchFromGitHub {
    repo = "sc";
    owner = "n-t-roff";
    tag = finalAttrs.version;
    hash = "sha256-qC7UQQqprT0Td7TCCe7iB9qJIBp47GW3aBAon27Katg=";
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
    description = "Curses-based spreadsheet calculator";

    longDescription = ''
      This is a fork of the old sc-7.16 application with attention paid to
      reduced compiler warnings, bugfixes, and functionality improvements
      (e.g. mouse suport, configurability via .scrc).
      See CHANGES-git or README.md for a full list of changes.
    '';

    homepage = "https://github.com/n-t-roff/sc";
    license = lib.licenses.unlicense;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.claes ];
  };
})
