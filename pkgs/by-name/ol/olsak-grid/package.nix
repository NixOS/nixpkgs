{
  lib,
  fetchzip,
  stdenv,
}:
stdenv.mkDerivation {
  pname = "olsak-grid";
  version = "1.2";
  src = fetchzip {
    url = "https://petr.olsak.net/ftp/olsak/grid/grid.tgz";
    hash = "sha256-76OxCKYDDP2y/hnH9IuElNVp57B4UE1Kgp0HRlgXZso=";
  };

  buildPhase = ''
    runHook preBuild
    $CC grid.c -o grid -fno-builtin-logf -std=c89
    runHook postBuild
  '';
  installPhase = ''
    runHook preInstall
    install -D -m755 grid "$out/bin/grid"
    runHook postInstall
  '';
  installCheckPhase = ''
    runHook preInstallCheck
    PATH="$out/bin:$PATH" ./testall
    runHook postInstallCheck
  '';
  doInstallCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Nonogram solver";
    homepage = "https://www.olsak.net/grid.html";
    mainProgram = "grid";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    maintainers = [ lib.maintainers.magistau ];
  };
}
