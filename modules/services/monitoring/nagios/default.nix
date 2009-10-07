# Nagios system/network monitoring daemon.
{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      nagios = {

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
  };
in

###### implementation
let
  cfg = config.services.nagios;
  inherit (pkgs.lib) mkIf mkThenElse;

  nagiosUser = "nagios";
  nagiosGroup = "nogroup";

  nagiosState = "/var/lib/nagios";
  nagiosLogDir = "/var/log/nagios";

  nagiosObjectDefs = [
    ./timeperiods.cfg
    ./host-templates.cfg
    ./service-templates.cfg
    ./commands.cfg
  ] ++ cfg.objectDefs;

  nagiosObjectDefsDir = pkgs.runCommand "nagios-objects" {inherit nagiosObjectDefs;}
    "ensureDir $out; ln -s $nagiosObjectDefs $out/";

  nagiosCfgFile = pkgs.writeText "nagios.cfg" "
  
    # Paths for state and logs.
    log_file=${nagiosLogDir}/current
    log_archive_path=${nagiosLogDir}/archive
    status_file=${nagiosState}/status.dat
    object_cache_file=${nagiosState}/objects.cache
    comment_file=${nagiosState}/comment.dat
    downtime_file=${nagiosState}/downtime.dat
    temp_file=${nagiosState}/nagios.tmp
    lock_file=/var/run/nagios.lock # Not used I think.
    state_retention_file=${nagiosState}/retention.dat

    # Configuration files.
    #resource_file=resource.cfg
    cfg_dir=${nagiosObjectDefsDir}

    # Uid/gid that the daemon runs under.
    nagios_user=${nagiosUser}
    nagios_group=${nagiosGroup}

    # Misc. options.
    illegal_macro_output_chars=`~$&|'\"<>
    retain_state_information=1
    
  ";

  # Plain configuration for the Nagios web-interface with no
  # authentication.
  nagiosCGICfgFile = pkgs.writeText "nagios.cgi.conf" "
    main_config_file=${nagiosCfgFile}
    use_authentication=0
    url_html_path=/nagios
  ";

  urlPath = cfg.urlPath;

  extraHttpdConfig = "
    ScriptAlias ${urlPath}/cgi-bin ${pkgs.nagios}/sbin

    <Directory \"${pkgs.nagios}/sbin\">
      Options ExecCGI
      AllowOverride None
      Order allow,deny
      Allow from all
      SetEnv NAGIOS_CGI_CONFIG ${nagiosCGICfgFile}
    </Directory>

    Alias ${urlPath} ${pkgs.nagios}/share

    <Directory \"${pkgs.nagios}/share\">
      Options None
      AllowOverride None
      Order allow,deny
      Allow from all
    </Directory>
  ";

  user = {
    name = nagiosUser;
    uid = config.ids.uids.nagios;
    description = "Nagios monitoring daemon";
    home = nagiosState;
  };

  job = {
    name = "nagios";
    
    # Run `nagios -v' to check the validity of the configuration file so
    # that a nixos-rebuild fails *before* we kill the running Nagios
    # daemon.
    buildHook = "${pkgs.nagios}/bin/nagios -v ${nagiosCfgFile}";

    job = "
      description \"Nagios monitoring daemon\"

      start on network-interfaces/started
      stop on network-interfaces/stop

      start script
        mkdir -m 0755 -p ${nagiosState} ${nagiosLogDir}
        chown ${nagiosUser} ${nagiosState} ${nagiosLogDir}
      end script

      respawn

      script
        for i in ${toString config.services.nagios.plugins}; do
          export PATH=$i/bin:$i/sbin:$i/libexec:$PATH
        done
        exec ${pkgs.nagios}/bin/nagios ${nagiosCfgFile}
      end script
    ";
  };
in

mkIf cfg.enable {
  require = [
    # ../../upstart-jobs/default.nix # config.services.extraJobs
    # ../../system/user.nix # users = { .. }
    # ? # config.environment.etc
    # ? # config.environment.extraPackages
    # ../../upstart-jobs/httpd.nix # config.services.httpd
    options
  ];

  environment = {
    # This isn't needed, it's just so that the user can type "nagiostats
    # -c /etc/nagios.cfg".
    etc = [
      { source = nagiosCfgFile;
        target = "nagios.cfg";
      }
    ];

    systemPackages = [pkgs.nagios];
  };

  users = {
    extraUsers = [user];
  };

  services = {
    extraJobs = [job];

    httpd = mkIf cfg.enableWebInterface {
      extraConfig = mkThenElse {
        thenPart = extraHttpdConfig;
        elsePart = "";
      };
    };
  };
}
