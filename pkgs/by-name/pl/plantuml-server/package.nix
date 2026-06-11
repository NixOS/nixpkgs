{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "plantuml-server";
  version = "1.2026.5";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${finalAttrs.version}/plantuml-v${finalAttrs.version}.war";
    hash = "sha256-Ub6Ao+m1hC+tEerkVnMXN2CMRf8CKg9XcB9E8JsunvY=";
    meta.identifiers.purlParts = {
      type = "github";
      spec = "plantuml/plantuml-server@${finalAttrs.version}";
    };
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
