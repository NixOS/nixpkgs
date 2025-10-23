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
  version = "0.56.6";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${finalAttrs.version}/metabase.jar";
    hash = "sha256-OQ9B1KpuYrtTL46cKJtKyuiHEwGSkF+PlAjb8FOv4zo=";
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
