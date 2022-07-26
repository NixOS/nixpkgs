{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.mail;

  configFile = if cfg.configuration != null then configurationFile else (escapeShellArg cfg.configFile);

  configurationFile = pkgs.writeText "prometheus-mail-exporter.conf" (builtins.toJSON (
    # removes the _module attribute, null values and converts attrNames to lowercase
    mapAttrs' (name: value:
      if name == "servers"
      then nameValuePair (toLower name)
        ((map (srv: (mapAttrs' (n: v: nameValuePair (toLower n) v)
          (filterAttrs (n: v: !(n == "_module" || v == null)) srv)
        ))) value)
      else nameValuePair (toLower name) value
    ) (filterAttrs (n: _: !(n == "_module")) cfg.configuration)
  ));

  serverOptions.options = {
    name = mkOption {
      type = types.str;
      description = ''
        Value for label 'configname' which will be added to all metrics.
      '';
    };
    server = mkOption {
      type = types.str;
      description = ''
        Hostname of the server that should be probed.
      '';
    };
    port = mkOption {
      type = types.int;
      example = 587;
      description = ''
        Port to use for SMTP.
      '';
    };
    from = mkOption {
      type = types.str;
      example = "exporteruser@domain.tld";
      description = ''
        Content of 'From' Header for probing mails.
      '';
    };
    to = mkOption {
      type = types.str;
      example = "exporteruser@domain.tld";
      description = ''
        Content of 'To' Header for probing mails.
      '';
    };
    detectionDir = mkOption {
      type = types.path;
      example = "/var/spool/mail/exporteruser/new";
      description = ''
        Directory in which new mails for the exporter user are placed.
        Note that this needs to exist when the exporter starts.
      '';
    };
    login = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "exporteruser@domain.tld";
      description = ''
        Username to use for SMTP authentication.
      '';
    };
    passphrase = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Password to use for SMTP authentication.
      '';
    };
  };

  exporterOptions.options = {
    monitoringInterval = mkOption {
      type = types.str;
      example = "10s";
      description = ''
        Time interval between two probe attempts.
      '';
    };
    mailCheckTimeout = mkOption {
      type = types.str;
      description = ''
        Timeout until mails are considered "didn't make it".
      '';
    };
    disableFileDeletion = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Disables the exporter's function to delete probing mails.
      '';
    };
    servers = mkOption {
      type = types.listOf (types.submodule serverOptions);
      default = [];
      example = literalExpression ''
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

        <emphasis>Note:</emphasis> if your mailserver has <citerefentry>
        <refentrytitle>rspamd</refentrytitle><manvolnum>8</manvolnum></citerefentry> configured,
        it can happen that emails from this exporter are marked as spam.

        It's possible to work around the issue with a config like this:
        <programlisting>
        {
          <link linkend="opt-services.rspamd.locals._name_.text">services.rspamd.locals."multimap.conf".text</link> = '''
            ALLOWLIST_PROMETHEUS {
              filter = "email:domain:tld";
              type = "from";
              map = "''${pkgs.writeText "allowmap" "domain.tld"}";
              score = -100.0;
            }
          ''';
        }
        </programlisting>
      '';
    };
  };
in
{
  port = 9225;
  extraOpts = {
    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        File containing env-vars to be substituted into the exporter's config.
      '';
    };
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify the mailexporter configuration file to use.
      '';
    };
    configuration = mkOption {
      type = types.nullOr (types.submodule exporterOptions);
      default = null;
      description = ''
        Specify the mailexporter configuration file to use.
      '';
    };
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
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
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
