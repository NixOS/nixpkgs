# Qingjian input method (Linux) NixOS module.
#
# Purpose:
#   1) Add the fcitx5-qingjian addon to `i18n.inputMethod.fcitx5.addons`;
#   2) Start the qingjian-server backend as a user systemd service inside the
#      graphical session, pointing QINGJIAN_RESOURCES at the qingjian-data
#      package by default.
#
# Configuration philosophy (hybrid):
#   - Infrastructure (whether to install, how the service runs, extra data
#     sources) is handled declaratively by this module's options;
#   - Personal preferences (dictionary toggles, keys, candidate style, sentence
#     model toggles, ...) live in the official runtime config
#     ~/.config/qingjian/config.toml (edits take effect after restarting
#     qingjian-server). Users who want declarative defaults can set
#     initialConfigFile: it is written once on first start, runtime edits are
#     kept afterwards, and rebuilds never overwrite it.
#
# Usage (in a NixOS configuration):
#   services.qingjian.enable = true;
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.qingjian;
in
{
  options.services.qingjian = {
    enable = lib.mkEnableOption "the Qingjian input method (fcitx5 addon + local Rust server)";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.fcitx5-qingjian;
      defaultText = lib.literalExpression "pkgs.fcitx5-qingjian";
      description = ''
        The fcitx5 addon package. Defaults to pkgs.fcitx5-qingjian; override
        when using a custom build of the addon.
      '';
    };

    serverPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qingjian-server;
      defaultText = lib.literalExpression "pkgs.qingjian-server";
      description = ''
        The qingjian-server backend package. Defaults to pkgs.qingjian-server;
        override when using a custom build of the server.
      '';
    };

    dataPackage = lib.mkOption {
      type = lib.types.package;
      default = pkgs.qingjian-data;
      defaultText = lib.literalExpression "pkgs.qingjian-data";
      description = ''
        The package providing the offline dictionary and sentence model data.
        Defaults to pkgs.qingjian-data (official data-v3). Override to track a
        newer upstream data release.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Optional custom resource root (a directory with data/generated,
        data/models/hanzhang-*, assets, ... as expected by the official layout).
        Defaults to null, in which case QINGJIAN_RESOURCES points at
        ${cfg.dataPackage}/share/qingjian/resources. Setting this overrides the
        data package.
      '';
    };

    serverArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--log-level"
        "debug"
      ];
      description = "Extra command-line arguments passed to qingjian-server.";
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        RUST_LOG = "debug";
      };
      description = "Extra environment variables injected into the service process.";
    };

    initialConfigFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Optional initial configuration (official config.toml). When set, it is
        written to ~/.config/qingjian/config.toml on first start and is never
        overwritten afterwards (runtime edits are preserved). When unset, the
        official runtime defaults are used.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod.fcitx5.addons = [ cfg.package ];

    # User service in the same session as fcitx5 (graphical-session), restarted
    # on login. NixOS systemd service options are top-level lowercase attributes
    # plus serviceConfig/unitConfig; there are no Unit/Service/Install sections.
    systemd.user.services.qingjian-server = {
      description = "qingjian input method Rust server";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      # These options have no defaults on nixpkgs 26.x but are read when the
      # unit is generated; align them explicitly with the systemd defaults.
      startLimitIntervalSec = 10;
      startLimitBurst = 5;
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${cfg.serverPackage}/bin/qingjian-linux-server"
          + lib.optionalString (cfg.serverArgs != [ ]) (" " + lib.concatStringsSep " " cfg.serverArgs);
        Restart = "on-failure";
        RestartSec = "2";
        Environment = [
          "QINGJIAN_RESOURCES=${
            if cfg.dataDir != null then toString cfg.dataDir else "${cfg.dataPackage}/share/qingjian/resources"
          }"
        ]
        ++ lib.mapAttrsToList (name: value: "${name}=${value}") cfg.extraEnvironment;
        # Write the initial config.toml on first start (only when missing, so
        # runtime edits are preserved).
        ExecStartPre = lib.mkIf (cfg.initialConfigFile != null) [
          (lib.concatStringsSep " " [
            "${pkgs.bash}/bin/bash"
            "-c"
            "mkdir -p %h/.config/qingjian && [ -e %h/.config/qingjian/config.toml ] || install -m 600 ${cfg.initialConfigFile} %h/.config/qingjian/config.toml"
          ])
        ];
      };
    };
  };
}
