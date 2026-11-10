{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.mail-tlsa-check;

  inherit (lib)
    boolToString
    collect
    concatStringsSep
    getExe
    isBool
    isList
    isString
    listToAttrs
    mapAttrsRecursive
    mkForce
    mkOption
    mkPackageOption
    optionalAttrs
    pipe
    toUpper
    types
    ;

  environment = pipe cfg.settings [
    (mapAttrsRecursive (
      path: value:
      optionalAttrs (value != null) {
        name = toUpper "MTCE_${concatStringsSep "_" path}";
        value =
          if isList value then
            concatStringsSep "," value
          else if isBool value then
            boolToString value
          else
            toString value;
      }
    ))
    (collect (x: isString x.name or false && isString x.value or false))
    listToAttrs
  ];
in
{
  port = 19309;
  extraOpts = {
    package = mkPackageOption pkgs "mail-tlsa-check-exporter" { };
    settings = mkOption {
      description = "Settings for the mail-tlsa-check-exporter";
      type = types.submodule {
        freeformType = types.attrs;

        options = {
          tlsa.record = mkOption {
            description = "The TLSA record to monitor";
            type = types.str;
            example = "_25._tcp.smtp.example.org";
          };
          check.timeout = mkOption {
            description = "Timeout for validation checks to complete before giving up, in milliseconds (e.g. 15000 for 15 seconds)";
            type = types.ints.positive;
            default = 15000;
            example = 10000;
          };
          ipv4.enabled = mkOption {
            description = "Whether to enable monitoring over IPv4";
            type = types.bool;
            default = true;
            example = false;
          };
          ipv6.enabled = mkOption {
            description = "Whether to enable monitoring over IPv6";
            type = types.bool;
            default = true;
            example = false;
          };
          server.port = mkOption {
            description = ''
              The port that the exporter listens on.

              ::: {.note}
              This is a read-only option that is read from {option}`services.prometheus.exporters.mail-tlsa-check.port`.
              :::
            '';
            type = types.port;
            default = cfg.port;
            defaultText = lib.literalExpression "config.services.prometheus.exporters.mail-tlsa-check.port";
            readOnly = true;
          };
          smtp = {
            hostname = mkOption {
              description = "The SMTP hostname to monitor";
              type = types.nullOr types.str;
              default = null;
              example = "smtp.example.org";
            };
            port = mkOption {
              description = ''
                The SMTP port to monitor

                ::: {.note}
                The exporter currently only supports explicit TLS (StartTLS), see <https://github.com/ietf-tools/mail-tlsa-check-exporter/issues/6>
                :::
              '';
              type = types.port;
              default = 587;
              example = 465;
            };
            client = mkOption {
              description = "The host to send in the SMTP EHLO command (name/domain/IP address)";
              type = types.str;
              default = "tlsa-smtp-synthetics-probe";
              example = "tlsa-exporter";
            };
          };
          imap = {
            hostname = mkOption {
              description = "The IMAP hostname to monitor";
              type = types.nullOr types.str;
              default = null;
              example = "imap.example.org";
            };
            port = mkOption {
              description = ''
                The IMAP port to monitor

                ::: {.note}
                The exporter currently only supports explicit TLS (StartTLS), see <https://github.com/ietf-tools/mail-tlsa-check-exporter/issues/6>
                :::
              '';
              type = types.port;
              default = 143;
            };
          };
        };
      };
    };
  };

  assertions = [
    {
      assertion = cfg.settings.ipv4.enabled || cfg.ipv6.enabled;
      message = "Both IPv4 and IPv6 are disabled, this is not possible as it won't monitor anything";
    }
    {
      assertion = cfg.settings.smtp.hostname != null || cfg.settings.imap.hostname != null;
      message = "Both SMTP and IMAP are disabled, this is not possible as it won't monitor anything";
    }
  ];

  serviceOpts = {
    inherit environment;

    serviceConfig = {
      ExecStart = getExe cfg.package;
      MemoryDenyWriteExecute = mkForce false; # because v8 won't start otherwise
      Restart = "always"; # because apparently, this service crashes and is intended to do so, see the upstream systemd unit
    };
  };
}
