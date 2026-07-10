{
  lib,
  fetchFromGitHub,
  maven,
  jdk25,
}:

maven.buildMavenPackage (finalAttrs: {
  pname = "secp256k1-jdk";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "bitcoinj";
    repo = "secp256k1-jdk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-kIWBgJ9OueNNDRKf1HHaxt6PFxK2iCuO0TFr8swbiL0=";
  };

  mvnJdk = jdk25;
  mvnGoal = "deploy"; # The secp256k1-jdk POM targets a `local-staging` repository using a file URL
  mvnOffline = false; # We need actions not allowed in Maven offline mode, but Nix sandboxing will still be enforced
  mvnParameters = "-Drevision=${finalAttrs.version}"; # make snapshot builds reproducible
  mvnHash = "sha256-87iDewdy/7lSyvROf1YyrsgvVUJtaivdHdSLig3Ea1Y=";

  strictDeps = true;
  __structuredAttrs = true;
  buildOffline = true;
  doCheck = false;

  installPhase = ''
    runHook preInstall

    # copy the full output in a maven repository directory structure
    mkdir -p "$out/share/maven-repo"
    cp -r target/repo/. "$out/share/maven-repo"

    # create symlinks for the binaries in $out/share/java
    mkdir -p "$out/share/java"
    ln -s "$out/share/maven-repo/org/bitcoinj/secp/secp-api/${finalAttrs.version}/secp-api-${finalAttrs.version}.jar" "$out/share/java"
    ln -s "$out/share/maven-repo/org/bitcoinj/secp/secp-bouncy/${finalAttrs.version}/secp-bouncy-${finalAttrs.version}.jar" "$out/share/java"
    ln -s "$out/share/maven-repo/org/bitcoinj/secp/secp-ffm/${finalAttrs.version}/secp-ffm-${finalAttrs.version}.jar" "$out/share/java"
    ln -s "$out/share/maven-repo/org/bitcoinj/secp/secp-graalvm/${finalAttrs.version}/secp-graalvm-${finalAttrs.version}.jar" "$out/share/java"

    runHook postInstall
  '';

  meta = {
    changelog = "https://github.com/bitcoinj/secp256k1-jdk/blob/master/CHANGELOG.adoc";
    description = "Java library providing Elliptic Curve Cryptography on curve secp256k1";
    longDescription = ''
      secp256k1-jdk is a Java library providing Elliptic Curve Cryptography using the SECG curve secp256k1.
      It provides ECDSA and Schnorr message signing, verification, and other functions.
    '';
    homepage = "https://github.com/bitcoinj/secp256k1-jdk";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      msgilligan
    ];
    platforms = jdk25.meta.platforms;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # dependencies pulled via FOD from Maven Central
    ];
  };
})
