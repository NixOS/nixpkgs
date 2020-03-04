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
    ${cfg.package}/bin/smokeping_cgi ${configPath}
  '';
in

{
  options = {
    services.smokeping = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the smokeping service";
      };
      alertConfig = mkOption {
        type = types.lines;
        default = ''
          to = root@localhost
          from = smokeping@localhost
        '';
        example = literalExample ''
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
        default = "http://${cfg.hostName}:${toString cfg.port}/smokeping.cgi";
        defaultText = "http://\${hostName}:\${toString port}/smokeping.cgi";
        example = "https://somewhere.example.com/smokeping.cgi";
        description = "URL to the smokeping cgi.";
      };
      config = mkOption {
        type = types.nullOr types.lines;
        default = null;
        description = "Full smokeping config supplied by the user. Overrides " +
          "and replaces any other configuration supplied.";
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
        example = literalExample ''
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
        default = config.networking.hostName;
        example = "somewhere.example.com";
        description = "DNS name for the urls generated in the cgi.";
      };
      imgUrl = mkOption {
        type = types.str;
        default = "http://${cfg.hostName}:${toString cfg.port}/cache";
        defaultText = "http://\${hostName}:\${toString port}/cache";
        example = "https://somewhere.example.com/cache";
        description = "Base url for images generated in the cgi.";
      };
      linkStyle = mkOption {
        type = types.enum ["original" "absolute" "relative"];
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
        example = "Joe Admin";
        description = "Real name of the owner of the instance";
      };
      ownerEmail = mkOption {
        type = types.str;
        default = "no-reply@${cfg.hostName}";
        example = "no-reply@yourdomain.com";
        description = "Email contact for owner";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.smokeping;
        defaultText = "pkgs.smokeping";
        description = "Specify a custom smokeping package";
      };
      port = mkOption {
        type = types.int;
        default = 8081;
        example = 8081;
        description = "TCP port to use for the web server.";
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
        description = "Default page layout for the web UI.";
      };
      probeConfig = mkOption {
        type = types.lines;
        default = ''
          + FPing
          binary = ${config.security.wrapperDir}/fping
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
        description = "User that runs smokeping and (optionally) thttpd";
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
      fping.source = "${pkgs.fping}/bin/fping";
      fping6.source = "${pkgs.fping}/bin/fping6";
    };
    environment.systemPackages = [ pkgs.fping ];
    users.users.${cfg.user} = {
      isNormalUser = false;
      isSystemUser = true;
      uid = config.ids.uids.smokeping;
      description = "smokeping daemon user";
      home = smokepingHome;
      createHome = true;
    };
    systemd.services.smokeping = {
      wantedBy = [ "multi-user.target"];
      serviceConfig = {
        User = cfg.user;
        Restart = "on-failure";
      };
      preStart = ''
        mkdir -m 0755 -p ${smokepingHome}/cache ${smokepingHome}/data
        rm -f ${smokepingHome}/cropper
        ln -s ${cfg.package}/htdocs/cropper ${smokepingHome}/cropper
        rm -f ${smokepingHome}/smokeping.fcgi
        ln -s ${cgiHome} ${smokepingHome}/smokeping.fcgi
        ${cfg.package}/bin/smokeping --check --config=${configPath}
        ${cfg.package}/bin/smokeping --static --config=${configPath}
      '';
      script = ''${cfg.package}/bin/smokeping --config=${configPath} --nodaemon'';
    };
    systemd.services.thttpd = mkIf cfg.webService {
      wantedBy = [ "multi-user.target"];
      requires = [ "smokeping.service"];
      partOf = [ "smokeping.service"];
      path = with pkgs; [ bash rrdtool smokeping thttpd ];
      script = ''thttpd -u ${cfg.user} -c "**.fcgi" -d ${smokepingHome} -p ${builtins.toString cfg.port} -D -nos'';
      serviceConfig.Restart = "always";
    };
  };

  meta.maintainers = with lib.maintainers; [ erictapen ];
}

