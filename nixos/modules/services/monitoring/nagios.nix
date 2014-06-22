# Nagios system/network monitoring daemon.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.nagios;

  nagiosState = "/var/lib/nagios";
  nagiosLogDir = "/var/log/nagios";

  nagiosObjectDefs = cfg.objectDefs;

  nagiosObjectDefsDir = pkgs.runCommand "nagios-objects" {inherit nagiosObjectDefs;}
    "ensureDir $out; ln -s $nagiosObjectDefs $out/";

  nagiosCfgFile = pkgs.writeText "nagios.cfg"
    ''
      # Paths for state and logs.
      log_file=${nagiosLogDir}/current
      log_archive_path=${nagiosLogDir}/archive
      status_file=${nagiosState}/status.dat
      object_cache_file=${nagiosState}/objects.cache
      temp_file=${nagiosState}/nagios.tmp
      lock_file=/var/run/nagios.lock # Not used I think.
      state_retention_file=${nagiosState}/retention.dat
      query_socket=${nagiosState}/nagios.qh
      check_result_path=${nagiosState}
      command_file=${nagiosState}/nagios.cmd

      # Configuration files.
      #resource_file=resource.cfg
      cfg_dir=${nagiosObjectDefsDir}

      # Uid/gid that the daemon runs under.
      nagios_user=nagios
      nagios_group=nogroup

      # Misc. options.
      illegal_macro_output_chars=`~$&|'"<>
      retain_state_information=1
    ''; # "

  # Plain configuration for the Nagios web-interface with no
  # authentication.
  nagiosCGICfgFile = pkgs.writeText "nagios.cgi.conf"
    ''
      main_config_file=${cfg.mainConfigFile}
      use_authentication=0
      url_html_path=${cfg.urlPath}
    '';

  extraHttpdConfig =
    ''
      ScriptAlias ${cfg.urlPath}/cgi-bin ${pkgs.nagios}/sbin

      <Directory "${pkgs.nagios}/sbin">
        Options ExecCGI
        AllowOverride None
        Order allow,deny
        Allow from all
        SetEnv NAGIOS_CGI_CONFIG ${cfg.cgiConfigFile}
      </Directory>

      Alias ${cfg.urlPath} ${pkgs.nagios}/share

      <Directory "${pkgs.nagios}/share">
        Options None
        AllowOverride None
        Order allow,deny
        Allow from all
      </Directory>
    '';

in
{
  options = {
    services.nagios = {
      enable = mkOption {
        default = false;
        description = "
          Whether to use <link
          xlink:href='http://www.nagios.org/'>Nagios</link> to monitor
          your system or network.
        ";
      };

      objectDefs = mkOption {
        description = "
          A list of Nagios object configuration files that must define
          the hosts, host groups, services and contacts for the
          network that you want Nagios to monitor.
        ";
      };

      plugins = mkOption {
        default = [pkgs.nagiosPluginsOfficial pkgs.ssmtp];
        description = "
          Packages to be added to the Nagios <envar>PATH</envar>.
          Typically used to add plugins, but can be anything.
        ";
      };

      mainConfigFile = mkOption {
        default = nagiosCfgFile;
        description = "
          Derivation for the main configuration file of Nagios.
        ";
      };

      cgiConfigFile = mkOption {
        default = nagiosCGICfgFile;
        description = "
          Derivation for the configuration file of Nagios CGI scripts
          that can be used in web servers for running the Nagios web interface.
        ";
      };

      enableWebInterface = mkOption {
        default = false;
        description = "
          Whether to enable the Nagios web interface.  You should also
          enable Apache (<option>services.httpd.enable</option>).
        ";
      };

      urlPath = mkOption {
        default = "/nagios";
        description = "
          The URL path under which the Nagios web interface appears.
          That is, you can access the Nagios web interface through
          <literal>http://<replaceable>server</replaceable>/<replaceable>urlPath</replaceable></literal>.
        ";
      };
    };
  };


  config = mkIf cfg.enable {
    users.extraUsers.nagios = {
      description = "Nagios user ";
      uid         = config.ids.uids.nagios;
      home        = nagiosState;
      createHome  = true;
    };

    # This isn't needed, it's just so that the user can type "nagiostats
    # -c /etc/nagios.cfg".
    environment.etc = [
      { source = cfg.mainConfigFile;
        target = "nagios.cfg";
      }
    ];

    environment.systemPackages = [ pkgs.nagios ];
    systemd.services.nagios = {
      description = "Nagios monitoring daemon";
      path     = [ pkgs.nagios ];
      wantedBy = [ "multi-user.target" ];
      after    = [ "network-interfaces.target" ];

      serviceConfig = {
        User = "nagios";
        Restart = "always";
        RestartSec = 2;
        PermissionsStartOnly = true;
      };

      preStart = ''
        mkdir -m 0755 -p ${nagiosState} ${nagiosLogDir}
        chown nagios ${nagiosState} ${nagiosLogDir}
      '';

      script = ''
        for i in ${toString cfg.plugins}; do
          export PATH=$i/bin:$i/sbin:$i/libexec:$PATH
        done
        exec ${pkgs.nagios}/bin/nagios ${cfg.mainConfigFile}
      '';
    };

    services.httpd.extraConfig = optionalString cfg.enableWebInterface extraHttpdConfig;
  };
}
