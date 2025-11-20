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
  version = "0.57.2";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${finalAttrs.version}/metabase.jar";
    hash = "sha256-5ty4j2xPIlI5kfhN4td1Am3aFp54gQv9X5Oll9Wq+oM=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${lib.getExe jre} $out/bin/metabase --add-flags "-jar $src"
    runHook postInstall
  '';

  meta = with lib; {
    description = "Business Intelligence and Embedded Analytics tool";
    homepage = "https://metabase.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.agpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
      thoughtpolice
      mmahut
    ];
    mainProgram = "metabase";
  };
  passthru.tests = {
    inherit (nixosTests) metabase;
  };
})
