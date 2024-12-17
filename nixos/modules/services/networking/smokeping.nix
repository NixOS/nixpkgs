{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.smokeping;
  smokepingHome = "/var/lib/smokeping";
  smokepingPidDir = "/run";
  configFile =
    if cfg.config == null
    then
      ''
        *** General ***
        cgiurl   = ${cfg.cgiUrl}
        contact = ${cfg.ownerEmail}
        datadir  = ${smokepingHome}/data
        imgcache = ${smokepingHome}/cache
        imgurl   = ${cfg.imgUrl}
        linkstyle = ${cfg.linkStyle}
        ${lib.optionalString (cfg.mailHost != "") "mailhost = ${cfg.mailHost}"}
        owner = ${cfg.owner}
        pagedir = ${smokepingHome}/cache
        piddir  = ${smokepingPidDir}
        ${lib.optionalString (cfg.sendmail != null) "sendmail = ${cfg.sendmail}"}
        smokemail = ${cfg.smokeMailTemplate}
        *** Presentation ***
        template = ${cfg.presentationTemplate}
        ${cfg.presentationConfig}
        *** Alerts ***
        ${cfg.alertConfig}
        *** Database ***
        ${cfg.databaseConfig}
        *** Probes ***
        ${cfg.probeConfig}
        *** Targets ***
        ${cfg.targetConfig}
        ${cfg.extraConfig}
      ''
    else
      cfg.config;

  configPath = pkgs.writeText "smokeping.conf" configFile;
  cgiHome = pkgs.writeScript "smokeping.fcgi" ''
    #!${pkgs.bash}/bin/bash
    ${cfg.package}/bin/smokeping_cgi /etc/smokeping.conf
  '';
in

{
  imports = [
    (mkRemovedOptionModule [ "services" "smokeping" "port" ] ''
      The smokeping web service is now served by nginx.
      In order to change the port, you need to change the nginx configuration under `services.nginx.virtualHosts.smokeping.listen.*.port`.
    '')
  ];

  options = {
    services.smokeping = {
      enable = mkEnableOption "smokeping service";

      alertConfig = mkOption {
        type = types.lines;
        default = ''
          to = root@localhost
          from = smokeping@localhost
        '';
        example = ''
          to = alertee@address.somewhere
          from = smokealert@company.xy

          +someloss
          type = loss
          # in percent
          pattern = >0%,*12*,>0%,*12*,>0%
          comment = loss 3 times  in a row;
        '';
        description = "Configuration for alerts.";
      };
      cgiUrl = mkOption {
        type = types.str;
        default = "http://${cfg.hostName}/smokeping.cgi";
        defaultText = literalExpression ''"http://''${hostName}/smokeping.cgi"'';
        example = "https://somewhere.example.com/smokeping.cgi";
        description = "URL to the smokeping cgi.";
      };
      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = ''
          Full smokeping config supplied by the user. Overrides
          and replaces any other configuration supplied.
        '';
      };
      databaseConfig = mkOption {
        type = types.lines;
        default = ''
          step     = 300
          pings    = 20
          # consfn mrhb steps total
          AVERAGE  0.5   1  1008
          AVERAGE  0.5  12  4320
              MIN  0.5  12  4320
              MAX  0.5  12  4320
          AVERAGE  0.5 144   720
              MAX  0.5 144   720
              MIN  0.5 144   720

        '';
        example = ''
          # near constant pings.
          step     = 30
          pings    = 20
          # consfn mrhb steps total
          AVERAGE  0.5   1  10080
          AVERAGE  0.5  12  43200
              MIN  0.5  12  43200
              MAX  0.5  12  43200
          AVERAGE  0.5 144   7200
              MAX  0.5 144   7200
              MIN  0.5 144   7200
        '';
        description = ''Configure the ping frequency and retention of the rrd files.
          Once set, changing the interval will require deletion or migration of all
          the collected data.'';
      };
      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Any additional customization not already included.";
      };
      hostName = mkOption {
        type = types.str;
        default = config.networking.fqdn;
        defaultText = literalExpression "config.networking.fqdn";
        example = "somewhere.example.com";
        description = "DNS name for the urls generated in the cgi.";
      };
      imgUrl = mkOption {
        type = types.str;
        default = "cache";
        defaultText = literalExpression ''"cache"'';
        example = "https://somewhere.example.com/cache";
        description = ''
          Base url for images generated in the cgi.

          The default is a relative URL to ensure it works also when e.g. forwarding
          the GUI port via SSH.
        '';
      };
      linkStyle = mkOption {
        type = types.enum [ "original" "absolute" "relative" ];
        default = "relative";
        example = "absolute";
        description = "DNS name for the urls generated in the cgi.";
      };
      mailHost = mkOption {
        type = types.str;
        default = "";
        example = "localhost";
        description = "Use this SMTP server to send alerts";
      };
      owner = mkOption {
        type = types.str;
        default = "nobody";
        example = "Bob Foobawr";
        description = "Real name of the owner of the instance";
      };
      ownerEmail = mkOption {
        type = types.str;
        default = "no-reply@${cfg.hostName}";
        defaultText = literalExpression ''"no-reply@''${hostName}"'';
        example = "no-reply@yourdomain.com";
        description = "Email contact for owner";
      };
      package = mkPackageOption pkgs "smokeping" { };
      host = mkOption {
        type = types.nullOr types.str;
        default = "localhost";
        example = "192.0.2.1"; # rfc5737 example IP for documentation
        description = ''
          Host/IP to bind to for the web server.

          Setting it to `null` skips passing the -h option to thttpd,
          which makes it bind to all interfaces.
        '';
      };
      presentationConfig = mkOption {
        type = types.lines;
        default = ''
          + charts
          menu = Charts
          title = The most interesting destinations
          ++ stddev
          sorter = StdDev(entries=>4)
          title = Top Standard Deviation
          menu = Std Deviation
          format = Standard Deviation %f
          ++ max
          sorter = Max(entries=>5)
          title = Top Max Roundtrip Time
          menu = by Max
          format = Max Roundtrip Time %f seconds
          ++ loss
          sorter = Loss(entries=>5)
          title = Top Packet Loss
          menu = Loss
          format = Packets Lost %f
          ++ median
          sorter = Median(entries=>5)
          title = Top Median Roundtrip Time
          menu = by Median
          format = Median RTT %f seconds
          + overview
          width = 600
          height = 50
          range = 10h
          + detail
          width = 600
          height = 200
          unison_tolerance = 2
          "Last 3 Hours"    3h
          "Last 30 Hours"   30h
          "Last 10 Days"    10d
          "Last 360 Days"   360d
        '';
        description = "presentation graph style";
      };
      presentationTemplate = mkOption {
        type = types.str;
        default = "${pkgs.smokeping}/etc/basepage.html.dist";
        defaultText = literalExpression ''"''${pkgs.smokeping}/etc/basepage.html.dist"'';
        description = "Default page layout for the web UI.";
      };
      probeConfig = mkOption {
        type = types.lines;
        default = ''
          + FPing
          binary = ${config.security.wrapperDir}/fping
        '';
        defaultText = literalExpression ''
          '''
            + FPing
            binary = ''${config.security.wrapperDir}/fping
          '''
        '';
        description = "Probe configuration";
      };
      sendmail = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/wrappers/bin/sendmail";
        description = "Use this sendmail compatible script to deliver alerts";
      };
      smokeMailTemplate = mkOption {
        type = types.str;
        default = "${cfg.package}/etc/smokemail.dist";
        defaultText = literalExpression ''"''${package}/etc/smokemail.dist"'';
        description = "Specify the smokemail template for alerts.";
      };
      targetConfig = mkOption {
        type = types.lines;
        default = ''
          probe = FPing
          menu = Top
          title = Network Latency Grapher
          remark = Welcome to the SmokePing website of xxx Company. \
                   Here you will learn all about the latency of our network.
          + Local
          menu = Local
          title = Local Network
          ++ LocalMachine
          menu = Local Machine
          title = This host
          host = localhost
        '';
        description = "Target configuration";
      };
      user = mkOption {
        type = types.str;
        default = "smokeping";
        description = "User that runs smokeping and (optionally) thttpd. A group of the same name will be created as well.";
      };
      webService = mkOption {
        type = types.bool;
        default = true;
        description = "Enable a smokeping web interface";
      };
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.sendmail != null && cfg.mailHost != "");
        message = "services.smokeping: sendmail and Mailhost cannot both be enabled.";
      }
    ];
    security.wrappers = {
      fping =
        {
          setuid = true;
          owner = "root";
          group = "root";
          source = "${pkgs.fping}/bin/fping";
        };
    };
    environment.etc."smokeping.conf".source = configPath;
    environment.systemPackages = [ pkgs.fping ];
    users.users.${cfg.user} = {
      isNormalUser = false;
      isSystemUser = true;
      group = cfg.user;
      description = "smokeping daemon user";
      home = smokepingHome;
    };

    users.users.${config.services.nginx.user} = mkIf cfg.webService {
      extraGroups = [
        cfg.user ## user == group in this module
      ];
    };

    users.groups.${cfg.user} = { };

    systemd.services.smokeping = {
      reloadTriggers = [ configPath ];
      requiredBy = [ "multi-user.target" ];
      serviceConfig = {
        User = cfg.user;
        Restart = "on-failure";
        ExecStart = "${cfg.package}/bin/smokeping --config=/etc/smokeping.conf --nodaemon";
      };
      preStart = ''
        ${cfg.package}/bin/smokeping --check --config=${configPath}
        ${cfg.package}/bin/smokeping --static --config=${configPath}
      '';
    };

    systemd.tmpfiles.rules = [
      # create cache and data directories
      "d ${smokepingHome}/cache 0750 ${cfg.user} ${cfg.user}"
      "d ${smokepingHome}/data 0750 ${cfg.user} ${cfg.user}"
      # create symlings
      "L+ ${smokepingHome}/css - - - - ${cfg.package}/htdocs/css"
      "L+ ${smokepingHome}/js - - - - ${cfg.package}/htdocs/js"
      "L+ ${smokepingHome}/smokeping.fcgi - - - - ${cgiHome}"
      # recursively adjust access mode and ownership (in case config change)
      "Z ${smokepingHome} 0750 ${cfg.user} ${cfg.user}"
    ];

    # use nginx to serve the smokeping web service
    services.fcgiwrap.instances.smokeping = mkIf cfg.webService {
      process.user = cfg.user;
      process.group = cfg.user;
      socket = { inherit (config.services.nginx) user group; };
    };
    services.nginx = mkIf cfg.webService {
      enable = true;
      virtualHosts."smokeping" = {
        serverName = mkDefault cfg.host;
        locations."/" = {
          root = smokepingHome;
          index = "smokeping.fcgi";
        };
        locations."/smokeping.fcgi" = {
          extraConfig = ''
            include ${config.services.nginx.package}/conf/fastcgi_params;
            fastcgi_pass unix:${config.services.fcgiwrap.instances.smokeping.socket.address};
            fastcgi_param SCRIPT_FILENAME ${smokepingHome}/smokeping.fcgi;
            fastcgi_param DOCUMENT_ROOT ${smokepingHome};
          '';
        };
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ nh2 ];
}
