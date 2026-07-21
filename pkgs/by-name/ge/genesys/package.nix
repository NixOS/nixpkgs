{
  lib,
  stdenv,
  fetchurl,
  jre,
  graphviz,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "genesys";
  version = "1.0.10";

  src = fetchurl {
    url = "https://github.com/mrlem/genesys/releases/download/v${finalAttrs.version}/genesys-${finalAttrs.version}.tar.gz";
    hash = "sha256-yfteToDL0FMFTraOCI5gXhAAimagI4dofeB7N5KieNc=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # The package is distributed as a prebuilt JAVA binary
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv bin lib $out
    wrapProgram $out/bin/genesys \
      --set JAVA_HOME "${jre.home}" \
      --prefix PATH : "${graphviz}/bin"

    runHook postInstall
  '';

  meta = {
    description = "Simple family tree generator that scales";
    homepage = "https://github.com/mrlem/genesys";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rogarb ];
    platforms = lib.platforms.all;
  };
})
