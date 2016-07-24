{ config, lib, pkgs, ... }:

with lib;
let

  cfg = config.services.smokeping;
  smokepingHome = "/var/lib/smokeping";
  smokepingPidDir = "/run";
  configFile = ''
    *** General ***
    owner = ${cfg.owner}
    contact = ${cfg.ownerEmail}
    mailhost = ${cfg.mailHost}
    #sendmail = /var/setuid-wrappers/sendmail
    imgcache = ${smokepingHome}/cache
    imgurl   = http://${cfg.hostName}:${builtins.toString cfg.port}/cache
    datadir  = ${smokepingHome}/data
    piddir  = ${smokepingPidDir}
    cgiurl   = http://${cfg.hostName}:${builtins.toString cfg.port}/smokeping.cgi
    smokemail = ${cfg.smokeMailTemplate}
    *** Presentation ***
    template = ${cfg.presentationTemplate}
    ${cfg.presentationConfig}
    #*** Alerts ***
    #${cfg.alertConfig}
    *** Database ***
    ${cfg.databaseConfig}
    *** Probes ***
    ${cfg.probeConfig}
    *** Targets ***
    ${cfg.targetConfig}
    ${cfg.extraConfig}
  '';
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
      webService = mkOption {
        type = types.bool;
        default = true;
        description = "Enable a smokeping web interface";
      };

      user = mkOption {
        type = types.string;
        default = "smokeping";
        description = "User that runs smokeping and (optionally) thttpd";
      };
      mailHost = mkOption {
        type = types.string;
        default = "127.0.0.1";
        description = "Use this SMTP server rather than localhost";
      };
      smokeMailTemplate = mkOption {
        type = types.string;
        default = "${cfg.package}/etc/smokemail.dist";
        description = "Specify the smokemail template for alerts.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.smokeping;
        description = "Specify a custom smokeping package";
      };
      owner = mkOption {
        type = types.string;
        default = "nobody";
        example = "Joe Admin";
        description = "Real name of the owner of the instance";
      };
      hostName = mkOption {
        type = types.string;
        default = config.networking.hostName;
        example = "somewhere.example.com";
        description = "DNS name for the urls generated in the cgi.";
      };
      port = mkOption {
        type = types.int;
        default = 8081;
        example = 8081;
        description = "TCP port to use for the web server.";
      };
      ownerEmail = mkOption {
        type = types.string;
        default = "no-reply@${cfg.hostName}";
        example = "no-reply@yourdomain.com";
        description = "Email contact for owner";
      };

      databaseConfig = mkOption {
        type = types.string;
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
      alertConfig = mkOption {
        type = types.string;
        default = "";
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
      presentationTemplate = mkOption {
        type = types.string;
        default = "${pkgs.smokeping}/etc/basepage.html.dist";
        description = "Default page layout for the web UI.";
      };

      presentationConfig = mkOption {
        type = types.string;
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
      probeConfig = mkOption {
        type = types.string;
        default = ''
          + FPing
          binary = ${pkgs.fping}/bin/fping
        '';
        description = "Probe configuration";
      };
      targetConfig = mkOption {
        type = types.string;
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
      extraConfig = mkOption {
        type = types.string;
        default = "";
        description = "Any additional customization not already included.";
      };

    };

  };

  config = mkIf cfg.enable {
    users.extraUsers = singleton {
      name = cfg.user;
      isNormalUser = false;
      isSystemUser = true;
      uid = config.ids.uids.smokeping;
      description = "smokeping daemon user";
      home = smokepingHome;
    };
    systemd.services.smokeping = {
      wantedBy = [ "multi-user.target"];
      serviceConfig.User = cfg.user;
      serviceConfig.PermissionsStartOnly = true;
      preStart = ''
        mkdir -m 0755 -p ${smokepingHome}/cache ${smokepingHome}/data
        chown -R ${cfg.user} ${smokepingHome}
        cp ${cgiHome} ${smokepingHome}/smokeping.fcgi
        ${cfg.package}/bin/smokeping --check --config=${configPath}
      '';
      script = ''${cfg.package}/bin/smokeping --config=${configPath} --nodaemon'';
    };
    systemd.services.thttpd = mkIf cfg.webService {
      wantedBy = [ "multi-user.target"];
      requires = [ "smokeping.service"];
      partOf = [ "smokeping.service"];
      path = with pkgs; [ bash rrdtool smokeping ];
      script = ''${pkgs.thttpd}/bin/thttpd -u ${cfg.user} -c "**.fcgi" -d ${smokepingHome} -p ${builtins.toString cfg.port} -D'';
    };
  };
}

