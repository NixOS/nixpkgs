{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.security.pki;

  cacertPackage = pkgs.cacert.override {
    blacklist = cfg.caCertificateBlacklist;
    extraCertificateFiles = cfg.certificateFiles;
    extraCertificateStrings = cfg.certificates;
  };
  caBundleName = if cfg.useCompatibleBundle then "ca-no-trust-rules-bundle.crt" else "ca-bundle.crt";
  caBundle = "${cacertPackage}/etc/ssl/certs/${caBundleName}";

in

{

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
      example = lib.literalExpression ''[ "''${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ]'';
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

    security.pki.caCertificateBlacklist = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "WoSign"
        "WoSign China"
        "CA WoSign ECC Root"
        "Certification Authority of WoSign G2"
      ];
      description = ''
        A list of blacklisted CA certificate names that won't be imported from
        the Mozilla Trust Store into
        {file}`/etc/ssl/certs/ca-certificates.crt`. Use the
        names from that file.
      '';
    };

  };

  config = lib.mkIf cfg.installCACerts {

    # NixOS canonical location + Debian/Ubuntu/Arch/Gentoo compatibility.
    environment.etc."ssl/certs/ca-certificates.crt".source = caBundle;

    # Old NixOS compatibility.
    environment.etc."ssl/certs/ca-bundle.crt".source = caBundle;

    # CentOS/Fedora compatibility.
    environment.etc."pki/tls/certs/ca-bundle.crt".source = caBundle;

    # P11-Kit trust source.
    environment.etc."ssl/trust-source".source = "${cacertPackage.p11kit}/etc/ssl/trust-source";

  };

}
