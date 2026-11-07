{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.security.pki;

  cacertPackage = pkgs.cacert.override {
    blocklistFailOnNonMatching = cfg.caCertificateBlocklistFailOnNonMatching ++ [
      # CVE-2026-111943
      "Comodo AAA Services root"
    ];
    blocklistIgnoreNonMatching = cfg.caCertificateBlocklistIgnoreNonMatching;
    extraCertificateFiles = cfg.certificateFiles;
    extraCertificateStrings = cfg.certificates;
  };
  caBundleName = if cfg.useCompatibleBundle then "ca-no-trust-rules-bundle.crt" else "ca-bundle.crt";
  caBundle = "${cacertPackage}/etc/ssl/certs/${caBundleName}";

in

{

  imports = [
    # Deprecated, with a custom warning in `config` that explains why.
    (lib.doRename {
      from = [
        "security"
        "pki"
        "caCertificateBlacklist"
      ];
      to = [
        "security"
        "pki"
        "caCertificateBlocklistFailOnNonMatching"
      ];
      visible = false;
      warn = false;
      use = lib.id;
    })
  ];

  options = {
    security.pki.installCACerts = lib.mkEnableOption "installing CA certificates to the system" // {
      default = true;
      internal = true;
    };

    security.pki.useCompatibleBundle = lib.mkEnableOption ''
      usage of a compatibility bundle.

      Such a bundle consists exclusively of `BEGIN CERTIFICATE` and no `BEGIN TRUSTED CERTIFICATE`,
      which is an OpenSSL specific PEM format.

      It is known to be incompatible with certain software stacks.

      Nevertheless, enabling this will strip all additional trust rules provided by the
      certificates themselves. This can have security consequences depending on your usecases
    '';

    security.pki.certificateFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''[ "''${pkgs.dn42-cacert}/etc/ssl/certs/dn42-ca.crt" ]'';
      description = ''
        A list of files containing trusted root certificates in PEM
        format. These are concatenated to form
        {file}`/etc/ssl/certs/ca-certificates.crt`, which is
        used by many programs that use OpenSSL, such as
        {command}`curl` and {command}`git`.
      '';
    };

    security.pki.certificates = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = lib.literalExpression ''
        [ '''
            NixOS.org
            =========
            -----BEGIN CERTIFICATE-----
            MIIGUDCCBTigAwIBAgIDD8KWMA0GCSqGSIb3DQEBBQUAMIGMMQswCQYDVQQGEwJJ
            TDEWMBQGA1UEChMNU3RhcnRDb20gTHRkLjErMCkGA1UECxMiU2VjdXJlIERpZ2l0
            ...
            -----END CERTIFICATE-----
          '''
        ]
      '';
      description = ''
        A list of trusted root certificates in PEM format.
      '';
    };

    security.pki.caCertificateBlocklistIgnoreNonMatching = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "WoSign"
        "WoSign China"
        "CA WoSign ECC Root"
        "Certification Authority of WoSign G2"
      ];
      description = ''
        A list of CA certificate names that won't be trusted from
        the Mozilla Trust Store in
        {file}`/etc/ssl/certs/ca-certificates.crt`. Use the
        names from that file.

        Names that match no certificate in the Mozilla Trust Store only
        produce a warning in the build log of the `nss-cacert` package.
        This is so that your system build doesn't break later when upstream
        removes a CA you blocklisted (which is common for distrusted CAs).
        As a consequence, a typo in a name is not detected; check that the
        blocklisted CAs are marked as not trusted in
        {file}`/etc/ssl/certs/ca-certificates.crt`, or temporarily use
        {option}`security.pki.caCertificateBlocklistFailOnNonMatching` and
        switch back to this option once you've checked that the name is
        correct.
      '';
    };

    security.pki.caCertificateBlocklistFailOnNonMatching = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "CFCA EV ROOT" ];
      description = ''
        Like {option}`security.pki.caCertificateBlocklistIgnoreNonMatching`,
        but the system build fails if one of these names matches no
        certificate in the Mozilla Trust Store.

        This detects typos in names, but it also means that the system build
        **will break in the future** when upstream removes one of these CAs from
        the Mozilla Trust Store, which is common for distrusted CAs.
        Until you remove the name from this list, that stops all updates of the
        system, including automatic security updates via
        {option}`system.autoUpgrade`.

        `security.pki.caCertificateBlacklist` is a deprecated alias of this
        option.
      '';
    };

    security.pki.caBundle = lib.mkOption {
      type = lib.types.path;
      readOnly = true;
      description = ''
        (Read-only) the path to the final bundle of certificate authorities as a single file.
      '';
    };
  };

  config = lib.mkMerge [
    {
      warnings = lib.optional options.security.pki.caCertificateBlacklist.isDefined "The option `security.pki.caCertificateBlacklist` is deprecated. It is an alias of `security.pki.caCertificateBlocklistFailOnNonMatching`, which fails the system build if a name matches no certificate in the Mozilla Trust Store. Upstream commonly removes distrusted CAs from it later, which then breaks the system build, and thus stops all updates, including automatic security updates via `system.autoUpgrade`. You can use `security.pki.caCertificateBlocklistFailOnNonMatching` to check that you got the names right, but use `security.pki.caCertificateBlocklistIgnoreNonMatching` (in particular in configurations you share with others) to not break automatic security updates when upstream CA certificate updates incorporate the removal.";
    }
    (lib.mkIf cfg.installCACerts {

      # NixOS canonical location + Debian/Ubuntu/Arch/Gentoo compatibility.
      environment.etc."ssl/certs/ca-certificates.crt".source = caBundle;

      # Old NixOS compatibility.
      environment.etc."ssl/certs/ca-bundle.crt".source = caBundle;

      # CentOS/Fedora compatibility.
      environment.etc."pki/tls/certs/ca-bundle.crt".source = caBundle;

      # P11-Kit trust source.
      environment.etc."ssl/trust-source".source = "${cacertPackage.p11kit}/etc/ssl/trust-source";
    })
    { security.pki.caBundle = caBundle; }
  ];

}
