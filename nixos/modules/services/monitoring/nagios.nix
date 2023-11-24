# Nagios system/network monitoring daemon.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nagios;

  nagiosState = "/var/lib/nagios";
  nagiosLogDir = "/var/log/nagios";
  urlPath = "/nagios";

  nagiosObjectDefs = cfg.objectDefs;

  nagiosObjectDefsDir = pkgs.runCommand "nagios-objects" {
      inherit nagiosObjectDefs;
      preferLocalBuild = true;
    } "mkdir -p $out; ln -s $nagiosObjectDefs $out/";

  nagiosCfgFile = let
    default = {
      log_file="${nagiosLogDir}/current";
      log_archive_path="${nagiosLogDir}/archive";
      status_file="${nagiosState}/status.dat";
      object_cache_file="${nagiosState}/objects.cache";
      temp_file="${nagiosState}/nagios.tmp";
      lock_file="/run/nagios.lock";
      state_retention_file="${nagiosState}/retention.dat";
      query_socket="${nagiosState}/nagios.qh";
      check_result_path="${nagiosState}";
      command_file="${nagiosState}/nagios.cmd";
      cfg_dir="${nagiosObjectDefsDir}";
      nagios_user="nagios";
      nagios_group="nagios";
      illegal_macro_output_chars="`~$&|'\"<>";
      retain_state_information="1";
    };
    lines = mapAttrsToList (key: value: "${key}=${value}") (default // cfg.extraConfig);
    content = concatStringsSep "\n" lines;
    file = pkgs.writeText "nagios.cfg" content;
    validated =  pkgs.runCommand "nagios-checked.cfg" {preferLocalBuild=true;} ''
      cp ${file} nagios.cfg
      # nagios checks the existence of /var/lib/nagios, but
      # it does not exist in the build sandbox, so we fake it
      mkdir lib
      lib=$(readlink -f lib)
      sed -i s@=${nagiosState}@=$lib@ nagios.cfg
      ${pkgs.nagios}/bin/nagios -v nagios.cfg && cp ${file} $out
    '';
    defaultCfgFile = if cfg.validateConfig then validated else file;
  in
  if cfg.mainConfigFile == null then defaultCfgFile else cfg.mainConfigFile;

  # Plain configuration for the Nagios web-interface with no
  # authentication.
  nagiosCGICfgFile = pkgs.writeText "nagios.cgi.conf"
    ''
      main_config_file=${cfg.mainConfigFile}
      use_authentication=0
      url_html_path=${urlPath}
    '';

  extraHttpdConfig =
    ''
      ScriptAlias ${urlPath}/cgi-bin ${pkgs.nagios}/sbin

      <Directory "${pkgs.nagios}/sbin">
        Options ExecCGI
        Require all granted
        SetEnv NAGIOS_CGI_CONFIG ${cfg.cgiConfigFile}
      </Directory>

      Alias ${urlPath} ${pkgs.nagios}/share

      <Directory "${pkgs.nagios}/share">
        Options None
        Require all granted
      </Directory>
    '';

in
{
  imports = [
    (mkRemovedOptionModule [ "services" "nagios" "urlPath" ] "The urlPath option has been removed as it is hard coded to /nagios in the nagios package.")
  ];

  meta.maintainers = with lib.maintainers; [ symphorien ];

  options = {
    services.nagios = {
      enable = mkEnableOption (lib.mdDoc ''[Nagios](https://www.nagios.org/) to monitor your system or network.'');

      objectDefs = mkOption {
        description = lib.mdDoc ''
          A list of Nagios object configuration files that must define
          the hosts, host groups, services and contacts for the
          network that you want Nagios to monitor.
        '';
        type = types.listOf types.path;
        example = literalExpression "[ ./objects.cfg ]";
      };

      plugins = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [ monitoring-plugins msmtp mailutils ];
        defaultText = literalExpression "[pkgs.monitoring-plugins pkgs.msmtp pkgs.mailutils]";
        description = lib.mdDoc ''
          Packages to be added to the Nagios {env}`PATH`.
          Typically used to add plugins, but can be anything.
        '';
      };

      mainConfigFile = mkOption {
        type = types.nullOr types.package;
        default = null;
        description = lib.mdDoc ''
          If non-null, overrides the main configuration file of Nagios.
        '';
      };

      extraConfig = mkOption {
        type = types.attrsOf types.str;
        example = {
          debug_level = "-1";
          debug_file = "/var/log/nagios/debug.log";
        };
        default = {};
        description = lib.mdDoc "Configuration to add to /etc/nagios.cfg";
      };

      validateConfig = mkOption {
        type = types.bool;
        default = pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform;
        defaultText = literalExpression "pkgs.stdenv.hostPlatform == pkgs.stdenv.buildPlatform";
        description = lib.mdDoc "if true, the syntax of the nagios configuration file is checked at build time";
      };

      cgiConfigFile = mkOption {
        type = types.package;
        default = nagiosCGICfgFile;
        defaultText = literalExpression "nagiosCGICfgFile";
        description = lib.mdDoc ''
          Derivation for the configuration file of Nagios CGI scripts
          that can be used in web servers for running the Nagios web interface.
        '';
      };

      enableWebInterface = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable the Nagios web interface.  You should also
          enable Apache ({option}`services.httpd.enable`).
        '';
      };

      virtualHost = mkOption {
        type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
        example = literalExpression ''
          { hostName = "example.org";
            adminAddr = "webmaster@example.org";
            enableSSL = true;
            sslServerCert = "/var/lib/acme/example.org/full.pem";
            sslServerKey = "/var/lib/acme/example.org/key.pem";
          }
        '';
        description = lib.mdDoc ''
          Apache configuration can be done by adapting {option}`services.httpd.virtualHosts`.
          See [](#opt-services.httpd.virtualHosts) for further information.
        '';
      };
    };
  };


  config = mkIf cfg.enable {
    users.users.nagios = {
      description = "Nagios user ";
      uid         = config.ids.uids.nagios;
      home        = nagiosState;
      group       = "nagios";
    };

    users.groups.nagios = { };

    # This isn't needed, it's just so that the user can type "nagiostats
    # -c /etc/nagios.cfg".
    environment.etc."nagios.cfg".source = nagiosCfgFile;

    environment.systemPackages = [ pkgs.nagios ];
    systemd.services.nagios = {
      description = "Nagios monitoring daemon";
      path     = [ pkgs.nagios ] ++ cfg.plugins;
      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" ];
      restartTriggers = [ nagiosCfgFile ];

      serviceConfig = {
        User = "nagios";
        Group = "nagios";
        Restart = "always";
        RestartSec = 2;
        LogsDirectory = "nagios";
        StateDirectory = "nagios";
        ExecStart = "${pkgs.nagios}/bin/nagios /etc/nagios.cfg";
      };
    };

    services.httpd.virtualHosts = optionalAttrs cfg.enableWebInterface {
      ${cfg.virtualHost.hostName} = mkMerge [ cfg.virtualHost { extraConfig = extraHttpdConfig; } ];
    };
  };
}
