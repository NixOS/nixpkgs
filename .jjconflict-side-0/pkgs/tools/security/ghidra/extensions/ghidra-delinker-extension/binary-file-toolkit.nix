{
  lib,
  fetchFromGitHub,
  maven,
}:
maven.buildMavenPackage (finalAttrs: {
  pname = "binary-file-toolkit";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "boricj";
    repo = "binary-file-toolkit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dhWBnieXVsFyBoaCBzQIVo7iLWrO6l5y0v1KK1xC/es=";
  };

  mvnHash = "sha256-vj6TVBN78pQ3C06LVqHK6J5VqZI0fuVBEsmmB+OU7kA=";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/"
    cp bft-*/target/*.jar "$out/"

    runHook postInstall
  '';

  meta = {
    description = "Set of Java libraries for manipulating toolchain file formats";
    homepage = "https://github.com/boricj/binary-file-toolkit";
    changelog = "https://github.com/boricj/binary-file-toolkit/releases";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ timschumi ];
  };
})
