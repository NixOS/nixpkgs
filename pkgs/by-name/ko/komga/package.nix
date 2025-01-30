{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk23_headless,
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "1.19.0";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/${version}/${pname}-${version}.jar";
    sha256 = "sha256-9klOS9VFKMiOWihJkXdk5/GTW6oRVrmSAKwK7es6IhM=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jdk23_headless}/bin/java $out/bin/komga --add-flags "-jar $src"
  '';

  passthru.tests = {
    komga = nixosTests.komga;
  };

  meta = {
    description = "Free and open source comics/mangas server";
    homepage = "https://komga.org/";
    license = lib.licenses.mit;
    platforms = jdk23_headless.meta.platforms;
    maintainers = with lib.maintainers; [
      tebriel
      govanify
    ];
    mainProgram = "komga";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
