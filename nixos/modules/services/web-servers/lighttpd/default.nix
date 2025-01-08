# NixOS module for lighttpd web server

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.lighttpd;

  # List of known lighttpd modules, ordered by how the lighttpd documentation
  # recommends them being imported:
  # https://redmine.lighttpd.net/projects/1/wiki/Server_modulesDetails
  #
  # Some modules are always imported and should not appear in the config:
  # disallowedModules = [ "mod_indexfile" "mod_dirlisting" "mod_staticfile" ];
  #
  # For full module list, see the output of running ./configure in the lighttpd
  # source.
  allKnownModules = [
    "mod_rewrite"
    "mod_redirect"
    "mod_alias"
    "mod_access"
    "mod_auth"
    "mod_status"
    "mod_simple_vhost"
    "mod_evhost"
    "mod_userdir"
    "mod_secdownload"
    "mod_fastcgi"
    "mod_proxy"
    "mod_cgi"
    "mod_ssi"
    "mod_compress"
    "mod_usertrack"
    "mod_expire"
    "mod_rrdtool"
    "mod_accesslog"
    # Remaining list of modules, order assumed to be unimportant.
    "mod_authn_dbi"
    "mod_authn_file"
    "mod_authn_gssapi"
    "mod_authn_ldap"
    "mod_authn_mysql"
    "mod_authn_pam"
    "mod_authn_sasl"
    "mod_cml"
    "mod_deflate"
    "mod_evasive"
    "mod_extforward"
    "mod_flv_streaming"
    "mod_geoip"
    "mod_magnet"
    "mod_mysql_vhost"
    "mod_openssl" # since v1.4.46
    "mod_scgi"
    "mod_setenv"
    "mod_trigger_b4_dl"
    "mod_uploadprogress"
    "mod_vhostdb" # since v1.4.46
    "mod_webdav"
    "mod_wstunnel" # since v1.4.46
  ];

  maybeModuleString =
    moduleName: lib.optionalString (lib.elem moduleName cfg.enableModules) ''"${moduleName}"'';

  modulesIncludeString = lib.concatStringsSep ",\n" (
    lib.filter (x: x != "") (map maybeModuleString allKnownModules)
  );

  configFile =
    if cfg.configText != "" then
      pkgs.writeText "lighttpd.conf" ''
        ${cfg.configText}
      ''
    else
      pkgs.writeText "lighttpd.conf" ''
        server.document-root = "${cfg.document-root}"
        server.port = ${toString cfg.port}
        server.username = "lighttpd"
        server.groupname = "lighttpd"

        # As for why all modules are loaded here, instead of having small
        # server.modules += () entries in each sub-service extraConfig snippet,
        # read this:
        #
        #   https://redmine.lighttpd.net/projects/1/wiki/Server_modulesDetails
        #   https://redmine.lighttpd.net/issues/2337
        #
        # Basically, lighttpd doesn't want to load (or even silently ignore) a
        # module for a second time, and there is no way to check if a module has
        # been loaded already. So if two services were to put the same module in
        # server.modules += (), that would break the lighttpd configuration.
        server.modules = (
            ${modulesIncludeString}
        )

        # Logging (logs end up in systemd journal)
        accesslog.use-syslog = "enable"
        server.errorlog-use-syslog = "enable"

        ${lib.optionalString cfg.enableUpstreamMimeTypes ''
          include "${pkgs.lighttpd}/share/lighttpd/doc/config/conf.d/mime.conf"
        ''}

        static-file.exclude-extensions = ( ".fcgi", ".php", ".rb", "~", ".inc" )
        index-file.names = ( "index.html" )

        ${lib.optionalString cfg.mod_userdir ''
          userdir.path = "public_html"
        ''}

        ${lib.optionalString cfg.mod_status ''
          status.status-url = "/server-status"
          status.statistics-url = "/server-statistics"
          status.config-url = "/server-config"
        ''}

        ${cfg.extraConfig}
      '';

in

{

  options = {

    services.lighttpd = {

      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Enable the lighttpd web server.
        '';
      };

      package = lib.mkPackageOption pkgs "lighttpd" { };

      port = lib.mkOption {
        default = 80;
        type = lib.types.port;
        description = ''
          TCP port number for lighttpd to bind to.
        '';
      };

      document-root = lib.mkOption {
        default = "/srv/www";
        type = lib.types.path;
        description = ''
          Document-root of the web server. Must be readable by the "lighttpd" user.
        '';
      };

      mod_userdir = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          If true, requests in the form /~user/page.html are rewritten to take
          the file public_html/page.html from the home directory of the user.
        '';
      };

      enableModules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "mod_cgi"
          "mod_status"
        ];
        description = ''
          List of lighttpd modules to enable. Sub-services take care of
          enabling modules as needed, so this option is mainly for when you
          want to add custom stuff to
          {option}`services.lighttpd.extraConfig` that depends on a
          certain module.
        '';
      };

      enableUpstreamMimeTypes = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to include the list of mime types bundled with lighttpd
          (upstream). If you disable this, no mime types will be added by
          NixOS and you will have to add your own mime types in
          {option}`services.lighttpd.extraConfig`.
        '';
      };

      mod_status = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Show server status overview at /server-status, statistics at
          /server-statistics and list of loaded modules at /server-config.
        '';
      };

      configText = lib.mkOption {
        default = "";
        type = lib.types.lines;
        example = "...verbatim config file contents...";
        description = ''
          Overridable config file contents to use for lighttpd. By default, use
          the contents automatically generated by NixOS.
        '';
      };

      extraConfig = lib.mkOption {
        default = "";
        type = lib.types.lines;
        description = ''
          These configuration lines will be appended to the generated lighttpd
          config file. Note that this mechanism does not work when the manual
          {option}`configText` option is used.
        '';
      };

    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = lib.all (x: lib.elem x allKnownModules) cfg.enableModules;
        message = ''
          One (or more) modules in services.lighttpd.enableModules are
          unrecognized.

          Known modules: ${toString allKnownModules}

          services.lighttpd.enableModules: ${toString cfg.enableModules}
        '';
      }
    ];

    services.lighttpd.enableModules = lib.mkMerge [
      (lib.mkIf cfg.mod_status [ "mod_status" ])
      (lib.mkIf cfg.mod_userdir [ "mod_userdir" ])
      # always load mod_accesslog so that we can log to the journal
      [ "mod_accesslog" ]
    ];

    systemd.services.lighttpd = {
      description = "Lighttpd Web Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${cfg.package}/sbin/lighttpd -D -f ${configFile}";
      serviceConfig.ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR1 $MAINPID";
      # SIGINT => graceful shutdown
      serviceConfig.KillSignal = "SIGINT";
    };

    users.users.lighttpd = {
      group = "lighttpd";
      description = "lighttpd web server privilege separation user";
      uid = config.ids.uids.lighttpd;
    };

    users.groups.lighttpd.gid = config.ids.gids.lighttpd;
  };
}
