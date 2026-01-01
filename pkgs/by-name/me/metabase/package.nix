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
  version = "0.56.10";

  src = fetchurl {
    url = "https://downloads.metabase.com/v${finalAttrs.version}/metabase.jar";
    hash = "sha256-otpNh9TJnUoHjAVVCkrsJO93nIeEfaNC8amZdTvreIE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    runHook preInstall
    makeWrapper ${lib.getExe jre} $out/bin/metabase --add-flags "-jar $src"
    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    description = "Business Intelligence and Embedded Analytics tool";
    homepage = "https://metabase.com";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "Business Intelligence and Embedded Analytics tool";
    homepage = "https://metabase.com";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.agpl3Only;
    platforms = platforms.all;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      thoughtpolice
      mmahut
    ];
    mainProgram = "metabase";
  };
  passthru.tests = {
    inherit (nixosTests) metabase;
  };
})
