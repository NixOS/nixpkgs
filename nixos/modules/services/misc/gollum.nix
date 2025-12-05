{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gollum;
in

{
  imports = [
    (lib.mkRemovedOptionModule
      [
        "services"
        "gollum"
        "mathjax"
      ]
      "MathJax rendering might be discontinued in the future, use services.gollum.math instead to enable KaTeX rendering or file a PR if you really need Mathjax"
    )
    (lib.mkRemovedOptionModule [
      "services"
      "gollum"
      "local-time"
    ] "Set the value in services.gollum.extraConfig")
  ];

  options.services.gollum = {
    enable = lib.mkEnableOption "Gollum, a git-powered wiki service";

    address = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "IP address on which the web server will listen.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 4567;
      description = "Port on which the web server will run.";
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      example = ''
        wiki_options = {
          show_local_time: true
        }

        Precious::App.set(:wiki_options, wiki_options)
      '';
      description = "Content of the configuration file";
    };

    math = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable support for math rendering using KaTeX";
    };

    allowUploads = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "dir"
          "page"
        ]
      );
      default = null;
      description = "Enable uploads of external files";
    };

    user-icons = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "gravatar"
          "identicon"
        ]
      );
      default = null;
      description = "Enable specific user icons for history view";
    };

    emoji = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Parse and interpret emoji tags";
    };

    h1-title = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use the first h1 as page title";
    };

    no-edit = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable editing pages";
    };

    branch = lib.mkOption {
      type = lib.types.str;
      default = "master";
      example = "develop";
      description = "Git branch to serve";
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/gollum";
      description = "Specifies the path of the repository directory. If it does not exist, Gollum will create it on startup.";
    };

    package = lib.mkPackageOption pkgs "gollum" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "gollum";
      description = "Specifies the owner of the wiki directory";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "gollum";
      description = "Specifies the owner group of the wiki directory";
    };
  };

  config = lib.mkIf cfg.enable {

    users.users.gollum = lib.mkIf (cfg.user == "gollum") {
      group = cfg.group;
      description = "Gollum user";
      createHome = false;
      isSystemUser = true;
    };

    users.groups."${cfg.group}" = { };

    systemd.tmpfiles.rules = [ "d '${cfg.stateDir}' - ${cfg.user} ${cfg.group} - -" ];

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
            ${lib.optionalString cfg.math "--math"} \
            ${lib.optionalString cfg.emoji "--emoji"} \
            ${lib.optionalString cfg.h1-title "--h1-title"} \
            ${lib.optionalString cfg.no-edit "--no-edit"} \
            ${lib.optionalString (cfg.allowUploads != null) "--allow-uploads ${cfg.allowUploads}"} \
            ${lib.optionalString (cfg.user-icons != null) "--user-icons ${cfg.user-icons}"} \
            ${cfg.stateDir}
        '';
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    erictapen
    bbenno
  ];
}
