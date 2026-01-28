{
  callPackage,
  fetchMavenArtifact,
  junixsocket-common,
  junixsocket-native-common,
}:
{
  keycloak-2fa-sms-authenticator = callPackage ./keycloak-2fa-sms-authenticator { };
  keycloak-config-cli = callPackage ./keycloak-config-cli { };
  keycloak-discord = callPackage ./keycloak-discord { };
  keycloak-enforce-mfa-authenticator = callPackage ./keycloak-enforce-mfa-authenticator { };
  keycloak-magic-link = callPackage ./keycloak-magic-link { };
  keycloak-metrics-spi = callPackage ./keycloak-metrics-spi { };
  keycloak-orgs = callPackage ./keycloak-orgs { };
  keycloak-remember-me-authenticator = callPackage ./keycloak-remember-me-authenticator { };
  keycloak-restrict-client-auth = callPackage ./keycloak-restrict-client-auth { };
  keycloak-secrets-vault-provider = callPackage ./keycloak-secrets-vault-provider { };
  scim-for-keycloak = callPackage ./scim-for-keycloak { };
  scim-keycloak-user-storage-spi = callPackage ./scim-keycloak-user-storage-spi { };

  # junixsocket provides Unix domain socket support for JDBC connections,
  # which is required for connecting to PostgreSQL via Unix socket.
  junixsocket-common = junixsocket-common.passthru.jar;
  junixsocket-native-common = junixsocket-native-common.passthru.jar;

  # These could theoretically be used by something other than Keycloak, but
  # there are no other quarkus apps in nixpkgs (as of 2023-08-21)
  quarkus-systemd-notify =
    (fetchMavenArtifact {
      groupId = "io.quarkiverse.systemd.notify";
      artifactId = "quarkus-systemd-notify";
      version = "1.0.1";
      hash = "sha256-3I4j22jyIpokU4kdobkt6cDsALtxYFclA+DV+BqtmLY=";
    }).passthru.jar;

  quarkus-systemd-notify-deployment =
    (fetchMavenArtifact {
      groupId = "io.quarkiverse.systemd.notify";
      artifactId = "quarkus-systemd-notify-deployment";
      version = "1.0.1";
      hash = "sha256-xHxzBxriSd/OU8gEcDG00VRkJYPYJDfAfPh/FkQe+zg=";
    }).passthru.jar;
}
