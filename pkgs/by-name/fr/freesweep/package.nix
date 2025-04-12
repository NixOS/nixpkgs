{
  fetchFromGitHub,
  ncurses,
  lib,
  stdenv,
  updateAutotoolsGnuConfigScriptsHook,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "freesweep";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "rwestlund";
    repo = "freesweep";
    rev = "v${version}";
    hash = "sha256-iuu81yHbNrjdPsimBrPK58PJ0d8i3ySM7rFUG/d8NJM";
  };

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    installShellFiles
  ];
  buildInputs = [ ncurses ];

  configureFlags = [ "--with-prefsdir=$out/share" ];

  enableParallelBuilding = true;

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
    maintainers = with maintainers; [ ];
    platforms = platforms.unix;
  };
}
