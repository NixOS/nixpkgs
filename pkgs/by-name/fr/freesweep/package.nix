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
  version = "1.1.0-unstable-2024-04-19";

  src = fetchFromGitHub {
    owner = "rwestlund";
    repo = "freesweep";
    rev = "68c0ee5b29d1087d216d95875a7036713cd25fc0";
    hash = "sha256-ZnAH7mIuBMFLdrtJOY8PzNbxv+GDEFAgyEtWCpTH2Us=";
  };

  patches = [
    ./0001-include-strings.h.patch
    ./0002-fix-Wformat-security.patch
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

  meta = with lib; {
    description = "Console minesweeper-style game written in C for Unix-like systems";
    mainProgram = "freesweep";
    homepage = "https://github.com/rwestlund/freesweep";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.sanana ];
    platforms = platforms.unix;
  };
}
