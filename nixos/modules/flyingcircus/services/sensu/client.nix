{ config, pkgs, lib, ... }:

with pkgs;
with lib;

let

  cfg = config.flyingcircus.services.sensu-client;

  check_timer = writeScript "check-timer.sh" ''
    #!${pkgs.bash}/bin/bash
    timer=$1
    output=$(systemctl status $1.timer)
    result=$?
    echo "$output" | iconv -c -f utf-8 -t ascii
    exit $(( result != 0 ? 2 : 0 ))
    '';

  local_sensu_configuration =
    if  pathExists /etc/local/sensu-client
    then "-d ${/etc/local/sensu-client}"
    else "";

  client_json = writeText "client.json" ''
    {
      "client": {
        "name": "${config.networking.hostName}",
        "address": "${config.networking.hostName}.gocept.net",
        "subscriptions": ["default"],
        "signature": "${cfg.password}"
      },
      "rabbitmq": {
        "host": "${cfg.server}",
        "user": "${config.networking.hostName}.gocept.net",
        "password": "${cfg.password}",
        "vhost": "/sensu"
      },
      "checks": ${builtins.toJSON
        (lib.mapAttrs (name: value: filterAttrs (name: value: name != "_module") value) cfg.checks)}
    }
  '';

  checkOptions = { name, config, ... }: {

    options = {
      notification = mkOption {
        type = types.str;
        description = "The notification on events.";
      };
      command = mkOption {
        type = types.str;
        description = "The command to execute as the check.";
      };
      interval = mkOption {
        type = types.int;
        default = 60;
        description = "The interval (in seconds) how often this check should be performed.";
      };
      standalone = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to schedule this check autonomously on the client.";
      };
    };
  };


in {

  options = {

    flyingcircus.services.sensu-client = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable the Sensu monitoring client daemon.
        '';
      };
      server = mkOption {
        type = types.str;
        description = ''
          The address of the server (RabbitMQ) to connect to.
        '';
      };
      password = mkOption {
        type = types.str;
        description = ''
          The password to connect with to server (RabbitMQ).
        '';
      };
      config = mkOption {
        type = types.lines;
        description = ''
          Contents of the sensu client configuration file.
        '';
      };
      checks = mkOption {
        default = {};
        type = types.attrsOf types.optionSet;
        options = [ checkOptions ];
        description = ''
          Checks that should be run by this client.
          Defined as attribute sets that conform to the JSON structure
          defined by Sensu:
          https://sensuapp.org/docs/latest/checks
        '';
      };
      extraOpts = mkOption {
        type = with types; listOf str;
        default = [];
        description = ''
          Extra options used when launching sensu.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    ids.gids.sensuclient = 207;
    ids.uids.sensuclient = 207;

    jobs.fcio-stubs-sensu-client = {
        description = "Create FC IO stubs for sensu";
        task = true;
        startOn = "started networking";
        script = ''
          install -d -o sensuclient -g service -m 775 /etc/local/sensu-client
        '';
    };

    users.extraGroups.sensuclient.gid = config.ids.gids.sensuclient;

    users.extraUsers.sensuclient = {
      description = "sensu client daemon user";
      uid = config.ids.uids.sensuclient;
      group = "sensuclient";
    };

    systemd.services.sensu-client = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.sensu pkgs.glibc pkgs.nagiosPluginsOfficial pkgs.bash pkgs.lm_sensors ];
      serviceConfig = {
        User = "sensuclient";
        ExecStart = "${sensu}/bin/sensu-client -L warn  -c ${client_json} ${local_sensu_configuration}";
        Restart = "always";
        RestartSec = "5s";
      };
        environment = { EMBEDDED_RUBY = "true"; };
    };

    flyingcircus.services.sensu-client.checks = {
      load = {
        notification = "Load is too high";
        command =  "check_load -r -w 0.8,0.8,0.8 -c 2,2,2";
        interval = 10;
      };
      swap = {
        notification = "Swap is running low";
        command = "check_swap -w 20% -c 10%";
        interval = 300;
      };
      ssh = {
        notification = "SSH server is not responding properly";
        command = "check_ssh localhost";
        interval = 300;
      };
      ntp_time = {
        notification = "Clock is skewed";
        command = "check_ntp_time -H 0.de.pool.ntp.org";
        interval = 300;
      };
      internet_uplink_ipv4 = {
        notification = "Internet (Google) is not available";
        command = "check_ping  -w 100,5% -c 200,10% -H google.com  -4";
      };
      internet_uplink_ipv6 = {
        notification = "Internet (Google) is not available";
        command = "check_ping  -w 100,5% -c 200,10% -H google.com  -6";
      };
      uptime = {
        notification = "Host was down";
        command = "check_uptime";
      };
      users = {
        notification = "Many users logged in";
        command = "check_users -w 5 -c 10";
      };
      systemd_units = {
        notification = "SystemD has failed units";
        command = "check-failed-units.rb";
      };
      disk = {
        notification = "Disk usage too high";
        command = "${pkgs.fcsensuplugins}/bin/check_disk -v -w 90 -c 95";
      };
      entropy = {
        notification = "Too little entropy available";
        command = "check-entropy.rb -w 120 -c 60";
      };
      local_resolver = {
        notification = "Local resolver not functional";
        command = "check-dns.rb -d ${config.networking.hostName}.gocept.net";
      };
      journal = {
        notification = "Errors in journal in the last hour";
        command = "check-journal.rb -q '([Ee]rror|[Ee]xception)' -s -60minutes";
        interval = 600;
      };
      manage = {
        notification = "The FC manage job is not enabled.";
        command = "${check_timer} fc-manage";
      };
      netstat_tcp = {
        notification = "Netstat TCP connections";
        command = "check-netstat-tcp.rb";
      };
      ethsrv_mtu = {
        notification = "ethsrv MTU @ 1500";
        command = "check-mtu.rb -i ethsrv -m 1500";
      };
      ethfe_mtu = {
        notification = "ethfe MTU @ 1500";
        command = "check-mtu.rb -i ethfe -m 1500";
      };
    };
  };

}
