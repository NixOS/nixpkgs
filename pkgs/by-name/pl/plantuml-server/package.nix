{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plantuml-server";
  version = "1.2026.1";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${finalAttrs.version}/plantuml-v${finalAttrs.version}.war";
    hash = "sha256-+r7SL+JXXAGC0Q7wxvohXBfBucVZzQPX3TIVd/tR0t8=";
  };

  dontUnpack = true;

  postInstall = ''
    mkdir -p "$out/webapps"
    cp "$src" "$out/webapps/plantuml.war"
  '';

  passthru.tests = {
    inherit (nixosTests) plantuml-server;
  };

  meta = {
    description = "Web application to generate UML diagrams on-the-fly";
    homepage = "https://plantuml.com/";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      truh
      anthonyroussel
    ];
  };
})
