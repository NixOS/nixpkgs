{ lib, stdenv, fetchurl, jre, graphviz, makeWrapper }:

stdenv.mkDerivation (finalAttrs: {
  pname = "genesys";
  version = "1.0.7";

  src = fetchurl {
    url = "https://github.com/mrlem/genesys/releases/download/v${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-I1lEVvwRiGf1f4zUtqKhSb+it/nC8WAmw5S6edquOj8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # The package is distributed as a prebuilt JAVA binary
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv bin lib $out
    wrapProgram $out/bin/${finalAttrs.pname} \
      --set JAVA_HOME "${jre.home}" \
      --prefix PATH : "${graphviz}/bin"

    runHook postInstall
  '';

  meta = {
    description = "A simple family tree generator that scales";
    homepage = "https://github.com/mrlem/genesys";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rogarb ];
    platforms = lib.platforms.all;
  };
})

