{ callPackage, fetchMavenArtifact }:

{
  scim-for-keycloak = callPackage ./scim-for-keycloak { };
  scim-keycloak-user-storage-spi = callPackage ./scim-keycloak-user-storage-spi { };
  keycloak-discord = callPackage ./keycloak-discord { };
  keycloak-metrics-spi = callPackage ./keycloak-metrics-spi { };
  keycloak-restrict-client-auth = callPackage ./keycloak-restrict-client-auth { };

  # These could theoretically be used by something other than Keycloak, but
  # there are no other quarkus apps in nixpkgs (as of 2023-08-21)
  quarkus-systemd-notify =
    (fetchMavenArtifact {
      groupId = "io.quarkiverse.systemd.notify";
      artifactId = "quarkus-systemd-notify";
      version = "1.0.2";
      hash = "sha256-tADHHxpGRzj6cZ0K83M5eQXkRs+Px4n8daNeQu00UHI=";
    }).passthru.jar;

  quarkus-systemd-notify-deployment =
    (fetchMavenArtifact {
      groupId = "io.quarkiverse.systemd.notify";
      artifactId = "quarkus-systemd-notify-deployment";
      version = "1.0.2";
      hash = "sha256-NB+JAt0T3lL6YYudZbSTxv107SRWzzECndjyAKbmJBE=";
    }).passthru.jar;
}
