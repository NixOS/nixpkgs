{
  lib,
  stdenv,
  fetchFromSourcehut,
  redo-apenwarr,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "slweb";
  version = "0.9.0";

  src = fetchFromSourcehut {
    owner = "~strahinja";
    repo = "slweb";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QDHcp5pCmapgOlJpDDyyC12JOfh/biDyF6O+iKGbOGg=";
  };

  nativeBuildInputs = [ redo-apenwarr ];

  installPhase = ''
    runHook preInstall
    export FALLBACKVER=${finalAttrs.version}
    PREFIX=$out redo install
    runHook postInstall
  '';

  enableParallelBuilding = true;

  passthru.tests.version = testers.testVersion {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Static website generator which aims at being simplistic";
    homepage = "https://strahinja.srht.site/slweb/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "slweb";
  };
})
