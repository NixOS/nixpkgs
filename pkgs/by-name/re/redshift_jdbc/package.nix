{
  lib,
  stdenv,
  fetchMavenArtifact,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "redshift-jdbc";
  version = "2.1.0.3";

  src = fetchMavenArtifact {
    artifactId = "redshift-jdbc42";
    groupId = "com.amazon.redshift";
    sha256 = "sha256-TO/JXh/pZ7tUZGfHqkzgZx18gLnISvnPVyGavzFv6vo=";
    inherit (finalAttrs) version;
  };

  installPhase = ''
    runHook preInstall
    install -m444 -D $src/share/java/redshift-jdbc42-${finalAttrs.version}.jar $out/share/java/redshift-jdbc42.jar
    runHook postInstall
  '';

  meta = {
    homepage = "https://github.com/aws/amazon-redshift-jdbc-driver/";
    description = "JDBC 4.2 driver for Amazon Redshift allowing Java programs to connect to a Redshift database";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sir4ur0n ];
  };
})
