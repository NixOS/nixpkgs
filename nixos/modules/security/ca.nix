{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.security.pki;

  cacertPackage = pkgs.cacert.override {
    blacklist = cfg.caCertificateBlacklist;
  };

  caCertificates = pkgs.runCommand "ca-certificates.crt"
    { files =
        cfg.certificateFiles ++
        [ (builtins.toFile "extra.crt" (concatStringsSep "\n" cfg.certificates)) ];
      preferLocalBuild = true;
     }
    ''
      cat $files > $out
    '';

in

{

  options = {

    security.pki.certificateFiles = mkOption {
      type = types.listOf types.path;
      default = [];
      example = literalExample "[ \"\${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt\" ]";
      description = ''
        A list of files containing trusted root certificates in PEM
        format. These are concatenated to form
        <filename>/etc/ssl/certs/ca-certificates.crt</filename>, which is
        used by many programs that use OpenSSL, such as
        <command>curl</command> and <command>git</command>.
      '';
    };

    security.pki.certificates = mkOption {
      type = types.listOf types.str;
      default = [];
      example = literalExample ''
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

    security.pki.caCertificateBlacklist = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "WoSign" "WoSign China"
        "CA WoSign ECC Root"
        "Certification Authority of WoSign G2"
      ];
      description = ''
        A list of blacklisted CA certificate names that won't be imported from
        the Mozilla Trust Store into
        <filename>/etc/ssl/certs/ca-certificates.crt</filename>. Use the
        names from that file.
      '';
    };

  };

  config = {

    security.pki.certificateFiles = [
      "${cacertPackage}/etc/ssl/certs/ca-bundle.crt"

      # GeoTrust Global CA is removed from NSS in version 3.60.
      # Unfortunately, some Apple hosts (api.push.apple.com &
      # store.storeimages.cdn-apple.com) still use certificates signed
      # by this root. To avoid, breaking these, Apple IST CA 2
      # intermediate certificate is enabled here. You can inspect this
      # CA at https://crt.sh/?caid=1597.
      (builtins.toFile "Apple_IST_CA_2.crt" ''
         Apple IST CA 2
         -----BEGIN CERTIFICATE-----
         MIIEnjCCA4agAwIBAgIQBVLH7/7sKSup8Th7B6+SnzANBgkqhkiG9w0BAQsFADBa
         MQswCQYDVQQGEwJJRTESMBAGA1UEChMJQmFsdGltb3JlMRMwEQYDVQQLEwpDeWJl
         clRydXN0MSIwIAYDVQQDExlCYWx0aW1vcmUgQ3liZXJUcnVzdCBSb290MB4XDTE4
         MTIxMjEyMDAwMFoXDTI1MDUwNzEyMDAwMFowYjEcMBoGA1UEAxMTQXBwbGUgSVNU
         IENBIDIgLSBHMTEgMB4GA1UECxMXQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxEzAR
         BgNVBAoTCkFwcGxlIEluYy4xCzAJBgNVBAYTAlVTMIIBIjANBgkqhkiG9w0BAQEF
         AAOCAQ8AMIIBCgKCAQEA0JOhHUdDIBayC2vrw9W06MeYzfPev+hN6eM2gAf8RRtq
         fEWGrlbTpAl/YQ1rXX5Sa320yDnE9Gc694POGW+GL35FfkccZ1LKlQVd4jZRhcDU
         Z4A1bxXdPv0d0v2PNFDY7HYqvuPT2uT9yOsoApYRlxdhHOnEWTtC3DLRCR3aptFD
         hv9esryMz2bbAYsCrpRI8ziP/eoyqAjshpdRlCQ+SUmWU+h5oUCB6QW7k5VR/OP9
         fBFL954IsxVJFQf50Tegm0sy9rXE3GrR/Art9uDFKaCoi3H+DZK8/lRwGAptx+0M
         +8ktBsOMhfzLhlzWNo4Siwl/+xkaONXwlDB6D6aM8wIDAQABo4IBVjCCAVIwHQYD
         VR0OBBYEFNh6lER8kHCQFp7dF5wBRAOG1iopMB8GA1UdIwQYMBaAFOWdWTCCR1jM
         rPoIVDaGezq1BE3wMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcD
         AQYIKwYBBQUHAwIwEgYDVR0TAQH/BAgwBgEB/wIBADA0BggrBgEFBQcBAQQoMCYw
         JAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTA6BgNVHR8EMzAx
         MC+gLaArhilodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vT21uaXJvb3QyMDI1LmNy
         bDBbBgNVHSAEVDBSMAwGCiqGSIb3Y2QFCwQwCAYGZ4EMAQICMDgGCmCGSAGG/WwA
         AgQwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cuZGlnaWNlcnQuY29tL0NQUzAN
         BgkqhkiG9w0BAQsFAAOCAQEAWgDobaZ4Dq8zSOdyWvCa+Tad60OIwE9qkz2o33KF
         CcAM/CvxXrcXTTYo9VJHninE+G9SguIdukkDDAOHMT8WvsqomydMXknQJVbREOAX
         KUKgS5q0/9ou9N1FjJvkhPGFzAbuLnSJtLomfJPxHW4h3l6bdliQodVQXd3xUbXR
         qTKNUbF9bIh4601+KhyZL0u0B/eTppf/1O5S+qFAyRADr1lvfIeNHZv11iyf4u7e
         uLBsXjyT3vPwxrihpAwB5pu/DhJWh4iv70Q7pcvAaRRfiJgMj3A0fFgvqvGbW9jm
         t04+Cr/PjpWeMFt3KKj3DRh4jJKjJUGt+JxdGGJ4tCGyCw==
         -----END CERTIFICATE-----
      '')
    ];

    # NixOS canonical location + Debian/Ubuntu/Arch/Gentoo compatibility.
    environment.etc."ssl/certs/ca-certificates.crt".source = caCertificates;

    # Old NixOS compatibility.
    environment.etc."ssl/certs/ca-bundle.crt".source = caCertificates;

    # CentOS/Fedora compatibility.
    environment.etc."pki/tls/certs/ca-bundle.crt".source = caCertificates;

  };

}
