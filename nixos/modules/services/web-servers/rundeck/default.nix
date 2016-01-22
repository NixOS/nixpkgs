{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.rundeck;
in {
  options = {
    services.rundeck = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable the rundeck job launcher service.
        '';
      };

      user = mkOption {
        default = "rundeck";
        type = types.str;
        description = ''
          User the rundeck server should execute under.
        '';
      };

      group = mkOption {
        default = "rundeck";
        type = types.str;
        description = ''
          If the default user "rundeck" is configured then this is the primary
          group of that user.
        '';
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "wheel" "dialout" ];
        description = ''
          List of extra groups that the "rundeck" user should be a part of.
        '';
      };

      home = mkOption {
        default = "/var/lib/rundeck";
        type = types.path;
        description = ''
          The path to use as RUNDECK_HOME. If the default user "rundeck" is configured then
          this is the home of the "rundeck" user.
        '';
      };

      listenAddress = mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = types.str;
        description = ''
          Specifies the bind address on which the rundeck HTTP interface listens.
          The default is the wildcard address.
        '';
      };

      port = mkOption {
        default = 4440;
        type = types.int;
        description = ''
          Specifies port number on which the rundeck HTTP interface listens.
          The default is 4440.
        '';
      };

      prefix = mkOption {
        default = "";
        example = "/rundeck";
        type = types.str;
        description = ''
          Specifies a urlPrefix to use with rundeck.
          If the example /rundeck is given, the rundeck server will be
          accessible using localhost:8080/rundeck.
        '';
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.git pkgs.jdk config.programs.ssh.package pkgs.nix ];
        type = types.listOf types.package;
        description = ''
          Packages to add to PATH for the rundeck process.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "rundeck") {
      name = "rundeck";
    };

    users.extraUsers = optional (cfg.user == "rundeck") {
      name = "rundeck";
      description = "rundeck user";
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
    };

    systemd.services.rundeck = {
      description = "rundeck job scheduler";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      path = cfg.packages;

      script = ''
        ${pkgs.jdk}/bin/java -jar -Dserver.http.host=${cfg.listenAddress} \
                                  -Dserver.http.port=${toString cfg.port} \
                                  -Dserver.web.context=${cfg.prefix}      \
                                  ${pkgs.rundeck} --basedir ${cfg.home}
      '';

      postStart = ''
        until ${pkgs.curl}/bin/curl -s -L ${cfg.listenAddress}:${toString cfg.port}${cfg.prefix} ; do
          sleep 10
        done
      '';

      serviceConfig = {
        User = cfg.user;
      };
    };
  };
}
