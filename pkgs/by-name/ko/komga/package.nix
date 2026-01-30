{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk25_headless,
  libwebp, # Fixes https://github.com/gotson/komga/issues/1294
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "1.24.0";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/${version}/${pname}-${version}.jar";
    sha256 = "sha256-1tg5etnXFOgOD6BekYErX7t7lnptR4tuiKwFO9tWk1U=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jdk25_headless}/bin/java $out/bin/komga --add-flags "-jar $src" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libwebp ]}
  '';

  passthru.tests = {
    komga = nixosTests.komga;
  };

  meta = {
    description = "Free and open source comics/mangas server";
    homepage = "https://komga.org/";
    license = lib.licenses.mit;
    platforms = jdk25_headless.meta.platforms;
    maintainers = with lib.maintainers; [
      tebriel
      govanify
    ];
    mainProgram = "komga";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
  };
}
