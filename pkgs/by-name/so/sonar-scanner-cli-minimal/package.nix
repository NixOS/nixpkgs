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
      "java.desktop"
      "java.logging"
      "java.management"
      "java.naming"
      "java.net.http"
      "java.sql"
      "java.xml"
      "jdk.crypto.ec"
      "jdk.jdwp.agent"
      "jdk.unsupported"
    ];
  };
}
