{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "dtach";
  version = "0-unstable-2025-06-20";

  src = fetchFromGitHub {
    owner = "crigler";
    repo = "dtach";
    rev = "b027c27b2439081064d07a86883c8e0b20a183c9";
    hash = "sha256-ilxBbrqwGe+jpFbQ93nfyp3HuDY0D7NgIXkIkw9YXkI=";
  };

  installPhase = ''
    runHook preInstall

    install -D dtach $out/bin/dtach

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://dtach.sourceforge.net/";
    description = "Program that emulates the detach feature of screen";

    longDescription = ''
      dtach is a tiny program that emulates the detach feature of
      screen, allowing you to run a program in an environment that is
      protected from the controlling terminal and attach to it later.
      dtach does not keep track of the contents of the screen, and
      thus works best with programs that know how to redraw
      themselves.
    '';

    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jmbaur ];
    mainProgram = "dtach";
  };
}
