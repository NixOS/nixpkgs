{
  lib,
  config,
  callPackage,
  fetchMavenArtifact,
  junixsocket-common,
  junixsocket-native-common,
}:
{
  apple-identity-provider-keycloak = callPackage ./apple-identity-provider-keycloak { };
  keycloak-2fa-app-authenticator = callPackage ./netzbegruenung-mfa-plugin.nix {
    pname = "keycloak-2fa-app-authenticator";
    module = "app-authenticator";
    description = "Keycloak MFA provider connecting a native mobile app for login approval";
  };
  keycloak-2fa-email-authenticator = callPackage ./netzbegruenung-mfa-plugin.nix {
    pname = "keycloak-2fa-email-authenticator";
    module = "email-authenticator";
    description = "Keycloak authentication provider for 2FA via email OTP";
  };
  keycloak-2fa-sms-authenticator = callPackage ./netzbegruenung-mfa-plugin.nix {
    pname = "keycloak-2fa-sms-authenticator";
    module = "sms-authenticator";
    description = "Keycloak authentication provider for 2FA via SMS";
  };
  keycloak-discord = callPackage ./keycloak-discord { };
  keycloak-enforce-mfa-authenticator = callPackage ./netzbegruenung-mfa-plugin.nix {
    pname = "keycloak-enforce-mfa-authenticator";
    module = "enforce-mfa";
    description = "Keycloak authenticator that enforces MFA";
  };
  keycloak-home-idp-discovery = callPackage ./keycloak-home-idp-discovery { };
  keycloak-magic-link = callPackage ./keycloak-magic-link { };
  keycloak-orgs = callPackage ./keycloak-orgs { };
  keycloak-remember-me-authenticator = callPackage ./keycloak-remember-me-authenticator { };
  keycloak-restrict-client-auth = callPackage ./keycloak-restrict-client-auth { };
  keycloak-secrets-vault-provider = callPackage ./keycloak-secrets-vault-provider { };

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
// lib.optionalAttrs config.allowAliases {
  keycloak-metrics-spi = throw "keycloak.plugins.keycloak-metrics-spi has been removed in favor of Keycloak's native metrics."; # Added 2026-07-14
  scim-for-keycloak = throw "keycloak.plugins.scim-for-keycloak has been removed as it is end-of-life upstream."; # Added 2026-07-14
  scim-keycloak-user-storage-spi = throw "keycloak.plugins.scim-keycloak-user-storage-spi has been removed as it is unmaintained upstream."; # Added 2026-07-14
}
