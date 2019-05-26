{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gollum;
in

{
  options.services.gollum = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Gollum service.";
    };

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = "IP address on which the web server will listen.";
    };

    port = mkOption {
      type = types.int;
      default = 4567;
      description = "Port on which the web server will run.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Content of the configuration file";
    };

    mathjax = mkOption {
      type = types.bool;
      default = false;
      description = "Enable support for math rendering using MathJax";
    };

    allowUploads = mkOption {
      type = types.nullOr (types.enum [ "dir" "page" ]);
      default = null;
      description = "Enable uploads of external files";
    };

    emoji = mkOption {
      type = types.bool;
      default = false;
      description = "Parse and interpret emoji tags";
    };

    branch = mkOption {
      type = types.str;
      default = "master";
      example = "develop";
      description = "Git branch to serve";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/gollum";
      description = "Specifies the path of the repository directory. If it does not exist, Gollum will create it on startup.";
    };

  };

  config = mkIf cfg.enable {

    users.users.gollum = {
      group = config.users.users.gollum.name;
      description = "Gollum user";
      createHome = false;
    };

    users.groups.gollum = { };

    systemd.services.gollum = {
      description = "Gollum wiki";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.git ];

      preStart = let
          userName = config.users.users.gollum.name;
          groupName = config.users.groups.gollum.name;
        in ''
        # All of this is safe to be run on an existing repo
        mkdir -p ${cfg.stateDir}
        git init ${cfg.stateDir}
        chmod 755 ${cfg.stateDir}
        chown -R ${userName}:${groupName} ${cfg.stateDir}
      '';

      serviceConfig = {
        User = config.users.users.gollum.name;
        Group = config.users.groups.gollum.name;
        PermissionsStartOnly = true;
        ExecStart = ''
          ${pkgs.gollum}/bin/gollum \
            --port ${toString cfg.port} \
            --host ${cfg.address} \
            --config ${builtins.toFile "gollum-config.rb" cfg.extraConfig} \
            --ref ${cfg.branch} \
            ${optionalString cfg.mathjax "--mathjax"} \
            ${optionalString cfg.emoji "--emoji"} \
            ${optionalString (cfg.allowUploads != null) "--allow-uploads ${cfg.allowUploads}"} \
            ${cfg.stateDir}
        '';
      };
    };
  };
}
