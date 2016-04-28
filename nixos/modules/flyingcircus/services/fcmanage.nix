{ config, lib, pkgs, ... }:

# Our management agent keeping the system up to date, configuring it based on
# changes to our nixpkgs clone and data from our directory

with lib;

let
  syscfg = config;
  cfg = config.flyingcircus;

in {
  options = {

    flyingcircus.agent = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatically running the Flying Circus management agent.";
      };

      steps = mkOption {
        type = types.str;
        default = "--directory --system-state --garbage 30 --maintenance --channel";
        description = "Steps to run by the agent.";
      };
    };

  };

  config = mkMerge [
    {
      # We always install the management agent, but we don't necessarily
      # enable it running automatically.
      environment.systemPackages = [
        pkgs.fcmanage
      ];

      systemd.services.fc-manage = {
        description = "Flying Circus Management Task";
        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;
        serviceConfig.Type = "oneshot";

        path = [config.system.build.nixos-rebuild];

        # This configuration is stolen from NixOS' own automatic updater.
        environment = config.nix.envVars // {
          inherit (config.environment.sessionVariables) NIX_PATH SSL_CERT_FILE;
          HOME = "/root";
          PATH = "/run/current-system/sw/bin:/run/current-system/sw/sbin";
        };
        script = ''
          ${pkgs.fcmanage}/bin/fc-manage -E ${cfg.enc_path} ${cfg.agent.steps}
          ${pkgs.fcmanage}/bin/fc-resize-root
        '';
      };

      # Remove the reboot marker during a reboot.
      systemd.tmpfiles.rules = [
        "r! /reboot"
        "R /var/spool/maintenance/archive/* - - - 90d"
      ];

    }

    (mkIf config.flyingcircus.agent.enable {

      systemd.timers.fc-manage = {
        description = "Timer for fc-manage";
        after = [ "network-online.target" ];
        wantedBy = [ "timers.target" ];
        timerConfig = {
          Unit = "fc-manage.service";
          # XXX This 10s thing is annoying. There seems to be an issue that
          # networking isn't _really_ up when the timer triggers for the
          # first time even though the 'network-online.target' is waited
          # for.
          OnStartupSec = "15s";
          OnUnitActiveSec = "10m";
          # Not yet supported by our systemd version.
          # RandomSec = "3m";
        };
      };

    })
  ];
}
