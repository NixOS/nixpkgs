# NixOS module for Buildbot Worker.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildbot-worker;

in {
  options = {
    services.buildbot-worker = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Buildbot Worker.";
      };

      user = mkOption {
        default = "bbworker";
        type = types.str;
        description = "User the buildbot Worker should execute under.";
      };

      group = mkOption {
        default = "bbworker";
        type = types.str;
        description = "Primary group of buildbot Worker user.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ "nixbld" ];
        description = "List of extra groups that the Buildbot Worker user should be a part of.";
      };

      home = mkOption {
        default = "/home/bbworker";
        type = types.path;
        description = "Buildbot home directory.";
      };

      buildbotDir = mkOption {
        default = "${cfg.home}/worker";
        type = types.path;
        description = "Specifies the Buildbot directory.";
      };

      workerUser = mkOption {
        default = "example-worker";
        type = types.str;
        description = "Specifies the Buildbot Worker user.";
      };

      workerPass = mkOption {
        default = "pass";
        type = types.str;
        description = "Specifies the Buildbot Worker password.";
      };

      masterUrl = mkOption {
        default = "localhost:9989";
        type = types.str;
        description = "Specifies the Buildbot Worker connection string.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.buildbot-worker;
        description = "Package to use for buildbot worker.";
        example = pkgs.buildbot-worker;
      };

      packages = mkOption {
        default = [ ];
        example = [ pkgs.git ];
        type = types.listOf types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };

    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "bbworker") {
      name = "bbworker";
    };

    users.extraUsers = optional (cfg.user == "bbworker") {
      name = "bbworker";
      description = "Buildbot Worker User.";
      isNormalUser = true;
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
    };

    systemd.services.buildbot-worker = {
      description = "Buildbot Worker.";
      after = [ "network.target" "buildbot-master.service" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages;

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -vp ${cfg.buildbotDir}
        ${cfg.package}/bin/buildbot-worker create-worker ${cfg.buildbotDir} ${cfg.masterUrl} ${cfg.workerUser} ${cfg.workerPass}
      '';

      serviceConfig = {
        Type = "forking";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;
        ExecStart = "${cfg.package}/bin/buildbot-worker start ${cfg.buildbotDir}";
      };

    };
  };

  meta.maintainers = with lib.maintainers; [ nand0p ];

}
