{
  lib,
  stdenv,
  fetchurl,
  jre,
  makeWrapper,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "swagger-codegen";
  version = "3.0.73";

  src = fetchurl {
    url = "mirror://maven/io/swagger/codegen/v3/swagger-codegen-cli/${finalAttrs.version}/swagger-codegen-cli-${finalAttrs.version}.jar";
    hash = "sha256-E2BP9qfAlHzrhzpRvxh7EHghD0ZOGIDdzZnT4VOZi2o=";
  };

  dontUnpack = true;

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/share/java/swagger-codegen-cli-${finalAttrs.version}.jar

    makeWrapper ${jre}/bin/java $out/bin/swagger-codegen3 \
      --add-flags "-jar $out/share/java/swagger-codegen-cli-${finalAttrs.version}.jar"

    runHook postInstall
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = "version";

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
