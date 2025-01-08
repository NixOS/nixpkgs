{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.mail;
  inherit (lib)
    lib.mkOption
    types
    mapAttrs'
    nameValuePair
    toLower
    filterAttrs
    escapeShellArg
    literalExpression
    mkIf
    concatStringsSep
    ;

  configFile =
    if cfg.configuration != null then configurationFile else (escapeShellArg cfg.configFile);

  configurationFile = pkgs.writeText "prometheus-mail-exporter.conf" (
    builtins.toJSON (
      # removes the _module attribute, null values and converts attrNames to lowercase
      mapAttrs' (
        name: value:
        if name == "servers" then
          nameValuePair (toLower name) (
            (map (
              srv:
              (mapAttrs' (n: v: nameValuePair (toLower n) v) (
                filterAttrs (n: v: !(n == "_module" || v == null)) srv
              ))
            ))
              value
          )
        else
          nameValuePair (toLower name) value
      ) (lib.filterAttrs (n: _: !(n == "_module")) cfg.configuration)
    )
  );

  serverOptions.options = {
    name = lib.mkOption {
      type = lib.types.str;
      description = ''
        Value for label 'configname' which will be added to all metrics.
      '';
    };
    server = lib.mkOption {
      type = lib.types.str;
      description = ''
        Hostname of the server that should be probed.
      '';
    };
    port = lib.mkOption {
      type = lib.types.port;
      example = 587;
      description = ''
        Port to use for SMTP.
      '';
    };
    from = lib.mkOption {
      type = lib.types.str;
      example = "exporteruser@domain.tld";
      description = ''
        Content of 'From' Header for probing mails.
      '';
    };
    to = lib.mkOption {
      type = lib.types.str;
      example = "exporteruser@domain.tld";
      description = ''
        Content of 'To' Header for probing mails.
      '';
    };
    detectionDir = lib.mkOption {
      type = lib.types.path;
      example = "/var/spool/mail/exporteruser/new";
      description = ''
        Directory in which new mails for the exporter user are placed.
        Note that this needs to exist when the exporter starts.
      '';
    };
    login = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "exporteruser@domain.tld";
      description = ''
        Username to use for SMTP authentication.
      '';
    };
    passphrase = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Password to use for SMTP authentication.
      '';
    };
  };

  exporterOptions.options = {
    monitoringInterval = lib.mkOption {
      type = lib.types.str;
      example = "10s";
      description = ''
        Time interval between two probe attempts.
      '';
    };
    mailCheckTimeout = lib.mkOption {
      type = lib.types.str;
      description = ''
        Timeout until mails are considered "didn't make it".
      '';
    };
    disableFileDeletion = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Disables the exporter's function to delete probing mails.
      '';
    };
    servers = lib.mkOption {
      type = lib.types.listOf (types.submodule serverOptions);
      default = [ ];
      example = lib.literalExpression ''
        [ {
          name = "testserver";
          server = "smtp.domain.tld";
          port = 587;
          from = "exporteruser@domain.tld";
          to = "exporteruser@domain.tld";
          detectionDir = "/path/to/Maildir/new";
        } ]
      '';
      description = ''
        List of servers that should be probed.

        *Note:* if your mailserver has {manpage}`rspamd(8)` configured,
        it can happen that emails from this exporter are marked as spam.

        It's possible to work around the issue with a config like this:
        ```
        {
          services.rspamd.locals."multimap.conf".text = '''
            ALLOWLIST_PROMETHEUS {
              filter = "email:domain:tld";
              type = "from";
              map = "''${pkgs.writeText "allowmap" "domain.tld"}";
              score = -100.0;
            }
          ''';
        }
        ```
      '';
    };
  };
in
{
  port = 9225;
  extraOpts = {
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        File containing env-vars to be substituted into the exporter's config.
      '';
    };
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Specify the mailexporter configuration file to use.
      '';
    };
    configuration = lib.mkOption {
      type = lib.types.nullOr (types.submodule exporterOptions);
      default = null;
      description = ''
        Specify the mailexporter configuration file to use.
      '';
    };
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      RuntimeDirectory = "prometheus-mail-exporter";
      ExecStartPre = [
        "${pkgs.writeShellScript "subst-secrets-mail-exporter" ''
          umask 0077
          ${pkgs.envsubst}/bin/envsubst -i ${configFile} -o ''${RUNTIME_DIRECTORY}/mail-exporter.json
        ''}"
      ];
      ExecStart = ''
        ${pkgs.prometheus-mail-exporter}/bin/mailexporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --config.file ''${RUNTIME_DIRECTORY}/mail-exporter.json \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
