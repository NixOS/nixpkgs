{
  lib,
  stdenvNoCC,
  fetchurl,
  writeTextFile,
  autoPatchelfHook,
  isabelle,
}:

let
  inherit (isabelle) platform;
  inherit (stdenvNoCC.hostPlatform) extensions isDarwin;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sqlite";
  version = "3.51.0.0";

  src = fetchurl {
    url = "https://isabelle.in.tum.de/components/sqlite-${finalAttrs.version}.tar.gz";
    hash = "sha256-gVhpKcOHS6Z/Y1q/Q4ntXHdvxhf0kAdMQLABtaFISPg=";
  };

  nativeBuildInputs = lib.optionals (!isDarwin) [
    autoPatchelfHook
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib" "$out/${platform}"
    cp lib/*.jar "$out/lib"
    cp ${platform}/*${extensions.sharedLibrary} "$out/${platform}"

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "sqlite-settings";
    text = ''
      ISABELLE_SQLITE_HOME="${finalAttrs.finalPackage}"

      classpath "$ISABELLE_SQLITE_HOME/lib/sqlite-jdbc-${finalAttrs.version}.jar"
      classpath "$ISABELLE_SQLITE_HOME/lib/slf4j-api-2.0.17.jar"
      classpath "$ISABELLE_SQLITE_HOME/lib/slf4j-nop-2.0.17.jar"
    '';
    destination = "/etc/settings";
  };
})
