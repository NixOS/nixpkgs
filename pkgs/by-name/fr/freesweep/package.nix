{
  fetchFromGitHub,
  ncurses,
  lib,
  stdenv,
  autoconf,
  automake,
  pkg-config,
  installShellFiles,
}:

stdenv.mkDerivation {
  pname = "freesweep";
  version = "1.0.2-unstable-2024-04-19";

  src = fetchFromGitHub {
    owner = "rwestlund";
    repo = "freesweep";
    rev = "68c0ee5b29d1087d216d95875a7036713cd25fc0";
    hash = "sha256-ZnAH7mIuBMFLdrtJOY8PzNbxv+GDEFAgyEtWCpTH2Us=";
  };

  # These patches are sent upstream in github:rwestlund/freesweep#18
  patches = [
    # strncasecmp and friends are declared in strings.h and not string.h on
    # systems with HAVE_STRINGS_H
    ./0001-include-strings.h.patch
    # Fixes a potential format string vulnerability and makes it compile with
    # -Wformat-security
    ./0002-fix-Wformat-security.patch
    # autoconf believes systems that handle malloc(0) differently from glibc
    # have a bad malloc implementation and will replace calls to malloc with
    # rpl_malloc. freesweep does not define rpl_malloc so this macro prevents
    # building for such systems, the easiest solution is to remove this macro
    ./0003-remove-ac_func_malloc.patch
  ];

  nativeBuildInputs = [
    autoconf
    automake
    pkg-config
    installShellFiles
  ];
  buildInputs = [ ncurses ];

  enableParallelBuilding = true;

  preConfigure = "./autogen.sh";

  installPhase = ''
    runHook preInstall
    install -D -m 0555 freesweep $out/bin/freesweep
    install -D -m 0444 sweeprc $out/share/sweeprc
    installManPage freesweep.6
    runHook postInstall
  '';

  meta = {
    description = "Console minesweeper-style game written in C for Unix-like systems";
    mainProgram = "freesweep";
    homepage = "https://github.com/rwestlund/freesweep";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lzcunt ];
    platforms = lib.platforms.unix;
  };
}
