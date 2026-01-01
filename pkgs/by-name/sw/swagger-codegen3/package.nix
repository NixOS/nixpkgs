{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  testers,
  swagger-codegen3,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "swagger-codegen";
  version = "3.0.75";

  src = fetchurl {
    url = "mirror://maven/io/swagger/codegen/v3/swagger-codegen-cli/${finalAttrs.version}/swagger-codegen-cli-${finalAttrs.version}.jar";
    hash = "sha256-Na6aWKq1SU/zWfxRf4ZH73lJy/dwbzz7coXP61zFv+E=";
=======
stdenv.mkDerivation rec {
  version = "3.0.62";
  pname = "swagger-codegen";

  jarfilename = "${pname}-cli-${version}.jar";

  nativeBuildInputs = [
    makeWrapper
  ];

  src = fetchurl {
    url = "mirror://maven/io/swagger/codegen/v3/${pname}-cli/${version}/${jarfilename}";
    sha256 = "sha256-23opx14BRfG7SjcSKXu59wmrrJsJiGebiMRvidV2gE8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dontUnpack = true;

<<<<<<< HEAD
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/java/swagger-codegen-cli-${finalAttrs.version}.jar

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen3 \
      --add-flags "-jar $out/share/java/swagger-codegen-cli-${finalAttrs.version}.jar"

    runHook postInstall
=======
  installPhase = ''
    install -D $src $out/share/java/${jarfilename}

    makeWrapper ${jre}/bin/java $out/bin/${pname}3 \
      --add-flags "-jar $out/share/java/${jarfilename}"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  passthru.tests.version = testers.testVersion {
    package = swagger-codegen3;
    command = "swagger-codegen3 version";
  };

<<<<<<< HEAD
  meta = {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen/tree/3.0.0";
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers._1000101 ];
    mainProgram = "swagger-codegen3";
    platforms = lib.platforms.all;
  };
})
=======
  meta = with lib; {
    description = "Allows generation of API client libraries (SDK generation), server stubs and documentation automatically given an OpenAPI Spec";
    homepage = "https://github.com/swagger-api/swagger-codegen/tree/3.0.0";
    sourceProvenance = with sourceTypes; [ binaryBytecode ];
    license = licenses.asl20;
    maintainers = [ maintainers._1000101 ];
    mainProgram = "swagger-codegen3";
    platforms = platforms.all;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
