{
  lib,
  stdenvNoCC,
  fetchurl,
  makeWrapper,
  jdk23_headless,
  libwebp, # Fixes https://github.com/gotson/komga/issues/1294
  nixosTests,
}:

stdenvNoCC.mkDerivation rec {
  pname = "komga";
  version = "1.22.0";

  src = fetchurl {
    url = "https://github.com/gotson/${pname}/releases/download/${version}/${pname}-${version}.jar";
    sha256 = "sha256-buc79CIADeZjQycEymTmskRD2+aY6nQecf0QqVDEgV8=";
  };

  nativeBuildInputs = [
    makeWrapper
  ];

  buildCommand = ''
    makeWrapper ${jdk23_headless}/bin/java $out/bin/komga --add-flags "-jar $src" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libwebp ]}
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
