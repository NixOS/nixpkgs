{
  lib,
  stdenv,
  fetchurl,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "plantuml-server";
  version = "1.2025.4";

  src = fetchurl {
    url = "https://github.com/plantuml/plantuml-server/releases/download/v${version}/plantuml-v${version}.war";
    hash = "sha256-SDNbuN6j3l5aejcRQIiczS4TsuvNcMFBne9YU1MFJ9Q=";
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
}
