{ lib }:
{
  tlsRecommendationsOption = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "modern"
        "intermediate"
        "old"
      ]
    );
    default = null;
    example = "intermediate";
    description = ''
      By default, H2O, without prejudice, will use as many TLS versions &
      cipher suites as it & the TLS library (OpenSSL) can support. The user is
      expected to hone settings for the security of their server. Setting some
      constraints is recommended, & if unsure about what TLS settings to use,
      this option gives curated TLS settings recommendations from Mozilla’s
      ‘SSL Configuration Generator’ project (see
      <https://ssl-config.mozilla.org>) or read more at Mozilla’s Wiki (see
      <https://wiki.mozilla.org/Security/Server_Side_TLS>).

      modern
      : Services with clients that support TLS 1.3 & don’t need backward
        compatibility

      intermediate
      : General-purpose servers with a variety of clients, recommended for
        almost all systems

      old
      : Compatible with a number of very old clients, & should be used only as
        a last resort

      The default for all virtual hosts can be set with
      services.h2o.defaultTLSRecommendations, but this value can be overridden
      on a per-host basis using services.h2o.hosts.<name>.tls.recommmendations.
      The settings will also be overidden by manual values set with
      services.settings.h2o.hosts.<name>.tls.extraSettings.

      NOTE: older/weaker ciphers might require overriding the OpenSSL version
      of H2O (such as `openssl_legacy`). This can be done with
      sevices.settings.h2o.package.
    '';
  };
}
