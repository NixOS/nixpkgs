{ lib
, stdenvNoCC
, fetchurl
, jre
, makeBinaryWrapper
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dynamodb-local";
  version = "2023-12-14";

  src = fetchurl {
    url = "https://d1ni2b6xgvw0s0.cloudfront.net/v2.x/dynamodb_local_${finalAttrs.version}.tar.gz";
    hash = "sha256-F9xTcLNAVFVbH7l0FlMuVNoLBrJS/UcHKXTkJh1n40w=";
  };

  sourceRoot = ".";

  nativeBuildInputs = [ makeBinaryWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/dynamodb-local
    cp -r DynamoDBLocal* $out/share/dynamodb-local

    makeBinaryWrapper ${jre}/bin/java $out/bin/dynamodb-local \
      --add-flags "-jar $out/share/dynamodb-local/DynamoDBLocal.jar"

    runHook postInstall
  '';

  meta = with lib; {
    description = "DynamoDB Local is a small client-side database and server that mimics the DynamoDB service.";
    homepage = "https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/DynamoDBLocal.html";
    license = licenses.unfree;
    mainProgram = "dynamodb-local";
    maintainers = with maintainers; [ shyim martinjlowm ];
    platforms = platforms.all;
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
  };
})
