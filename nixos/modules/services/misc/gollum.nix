{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gollum;
in

{
  options.services.gollum = {
    enable = mkEnableOption (lib.mdDoc "Gollum service");

    address = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = lib.mdDoc "IP address on which the web server will listen.";
    };

    port = mkOption {
      type = types.port;
      default = 4567;
      description = lib.mdDoc "Port on which the web server will run.";
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc "Content of the configuration file";
    };

    mathjax = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Enable support for math rendering using MathJax";
    };

    allowUploads = mkOption {
      type = types.nullOr (types.enum [ "dir" "page" ]);
      default = null;
      description = lib.mdDoc "Enable uploads of external files";
    };

    user-icons = mkOption {
      type = types.nullOr (types.enum [ "gravatar" "identicon" ]);
      default = null;
      description = lib.mdDoc "Enable specific user icons for history view";
    };

    emoji = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Parse and interpret emoji tags";
    };

    h1-title = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Use the first h1 as page title";
    };

    no-edit = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Disable editing pages";
    };

    local-time = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Use the browser's local timezone instead of the server's for displaying dates.";
    };

    branch = mkOption {
      type = types.str;
      default = "master";
      example = "develop";
      description = lib.mdDoc "Git branch to serve";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/gollum";
      description = lib.mdDoc "Specifies the path of the repository directory. If it does not exist, Gollum will create it on startup.";
    };

    package = mkOption {
      type = types.package;
      default = pkgs.gollum;
      defaultText = literalExpression "pkgs.gollum";
      description = lib.mdDoc ''
        The package used in the service
      '';
    };

    user = mkOption {
      type = types.str;
      default = "gollum";
      description = lib.mdDoc "Specifies the owner of the wiki directory";
    };

    group = mkOption {
      type = types.str;
      default = "gollum";
      description = lib.mdDoc "Specifies the owner group of the wiki directory";
    };
  };

  config = mkIf cfg.enable {

    users.users.gollum = mkIf (cfg.user == "gollum") {
      group = cfg.group;
      description = "Gollum user";
      createHome = false;
      isSystemUser = true;
    };

    users.groups."${cfg.group}" = { };

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - ${config.users.users.gollum.name} ${config.users.groups.gollum.name} - -"
    ];

    systemd.services.gollum = {
      description = "Gollum wiki";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.git ];

      preStart = ''
        # This is safe to be run on an existing repo
        git init ${cfg.stateDir}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = ''
          ${cfg.package}/bin/gollum \
            --port ${toString cfg.port} \
            --host ${cfg.address} \
            --config ${pkgs.writeText "gollum-config.rb" cfg.extraConfig} \
            --ref ${cfg.branch} \
            ${optionalString cfg.mathjax "--mathjax"} \
            ${optionalString cfg.emoji "--emoji"} \
            ${optionalString cfg.h1-title "--h1-title"} \
            ${optionalString cfg.no-edit "--no-edit"} \
            ${optionalString cfg.local-time "--local-time"} \
            ${optionalString (cfg.allowUploads != null) "--allow-uploads ${cfg.allowUploads}"} \
            ${optionalString (cfg.user-icons != null) "--user-icons ${cfg.user-icons}"} \
            ${cfg.stateDir}
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ erictapen bbenno ];
}
