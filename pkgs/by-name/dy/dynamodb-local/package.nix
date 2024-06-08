{ lib
, stdenvNoCC
, fetchurl
, jdk_headless
, jre_minimal
, makeBinaryWrapper
, curl
, jq
, yq
, dynamodb-local
, testers
, common-updater-scripts
, writeShellScript
}:
let
  jre = jre_minimal.override {
    modules = [
      "java.logging"
      "java.xml"
      "java.desktop"
      "java.management"
      "java.naming"
    ];
    jdk = jdk_headless;
  };
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "dynamodb-local";
  version = "2.5.0";

  src = fetchurl {
    url = "https://d1ni2b6xgvw0s0.cloudfront.net/v2.x/dynamodb_local_2024-05-28.tar.gz";
    hash = "sha256-vwExzekzNdNWcEOHZ22b5F9pADdqZ4XSWscrndfPcsQ=";
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

  passthru = {
    tests.version = testers.testVersion {
      package = dynamodb-local;
    };
    updateScript = writeShellScript "update-dynamodb-local" ''
      set -o errexit
      export PATH="${lib.makeBinPath [ curl jq yq common-updater-scripts ]}:$PATH"

      NEW_VERSION=$(curl -s https://repo1.maven.org/maven2/com/amazonaws/DynamoDBLocal/maven-metadata.xml | xq -r '.metadata.versioning.latest')
      NEW_VERSION_DATE=$(curl -s https://repo1.maven.org/maven2/com/amazonaws/DynamoDBLocal/maven-metadata.xml | xq -r '.metadata.versioning.lastUpdated | "\(.[:4])-\(.[4:6])-\(.[6:8])"')

      if [[ "${finalAttrs.version}" = "$NEW_VERSION" ]]; then
          echo "The new version same as the old version."
          exit 0
      fi

      DOWNLOAD_URL="https://d1ni2b6xgvw0s0.cloudfront.net/v2.x/dynamodb_local_$NEW_VERSION_DATE.tar.gz"
      NIX_HASH=$(nix hash to-sri sha256:$(nix-prefetch-url $DOWNLOAD_URL))

      update-source-version "dynamodb-local" "$NEW_VERSION" "$NIX_HASH" "$DOWNLOAD_URL"
    '';
  };

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
