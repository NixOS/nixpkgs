{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "hexdiff";
  version = "unstable-2018-01-24";

  src = fetchFromGitHub {
    owner = "ahroach";
    repo = "hexdiff";
    rev = "3e96f27e65167c619ede35ab04232163dc273e69";
    sha256 = "sha256-G6Qi7e4o+0ahcslJ8UfJrdoc8NNkY+nl6kyDlkJCo9I=";
  };

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    $CC -o hexdiff hexdiff.c

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D hexdiff  -t $out/bin/

    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/ahroach/hexdiff";
    description = "Terminal application for differencing two binary files, with color-coded output";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ rogarb ];
    platforms = lib.platforms.linux;
    mainProgram = "hexdiff";
  };
}
