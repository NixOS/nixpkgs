{
  lib,
  sonar-scanner-cli,
  jre_minimal,
  jdk_headless,
}:

sonar-scanner-cli.override {
  jre = jre_minimal.override {
    jdk = jdk_headless;
    modules = [
      "java.base"
      "java.logging"
      "java.naming"
      "java.sql"
      "java.xml"
      "jdk.crypto.ec"
      "jdk.jdwp.agent"
      "jdk.unsupported"
    ];
  };
}
