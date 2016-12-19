# This module defines global configuration for the xonsh.

{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.xonsh;

in

{

  options = {

    programs.xonsh = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to configure xnosh as an interactive shell.
        '';
        type = types.bool;
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.xonsh.override { configFile = \"/path/to/xonshrc\"; }";
        description = ''
          xonsh package to use.
        '';
      };

      config = mkOption {
        default = "";
        description = "Control file to customize your shell behavior.";
        type = types.lines;
      };

    };

  };

  config = mkIf cfg.enable {

    environment.etc."xonshrc".text = cfg.config;

    environment.systemPackages = [ pkgs.xonsh ];

    environment.shells =
      [ "/run/current-system/sw/bin/xonsh"
        "/var/run/current-system/sw/bin/xonsh"
        "${pkgs.xonsh}/bin/xonsh"
      ];

  };

}

