{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  jre_headless,
  nixosTests,
}:

let
  jre = jre_headless;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "metabase";
  version = "0.58.5";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${finalAttrs.version}/metabase.jar";
    hash = "sha256-JjpDsI7G0b5YVjICXe9ZeprnipeyVg79qW42LTcE4U4=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${lib.getExe jre} $out/bin/metabase --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = {
    description = "Business Intelligence and Embedded Analytics tool";
    homepage = "https://metabase.com";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      thoughtpolice
      mmahut
    ];
    mainProgram = "metabase";
  };
  passthru.tests = {
    inherit (nixosTests) metabase;
  };
})
