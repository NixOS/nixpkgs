{ config, lib, pkgs, ... }:

# Our management agent keeping the system up to date, configuring it based on
# changes to our nixpkgs clone and data from our directory

with lib;

let

# Need to turn this into a real package once we require more
manage_script = pkgs.stdenv.mkDerivation {
  name = "fc-manage-0.1";

  src = ./src;

  installPhase = ''
    mkdir -p $out/bin
    cp $src/update.py $out/fc-manage.py
    cat <<__EOF__ > $out/bin/fc-manage
    #!/bin/bash
    # The current system reference is bad because I wasn't able tof figure out
    # retrieving the path of all all dependencies (and theirs).
    PATH=/run/current-system/sw/bin:/run/current-system/sw/sbin
    ${pkgs.python3}/bin/python3 $out/fc-manage.py \$@
    __EOF__
    chmod +x $out/bin/fc-manage
    '';
  };

in

{

  options = {

    flyingcircus.agent = {

      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable automatically running the Flying Circus management agent.";
      };

      steps = mkOption {
        type = types.str;
        default = "--directory --channel";
        description = "Steps to run by the agent.";
      };

    };

  };

  config = mkMerge [
    {
      # We always install the management agent, but we don't necessarily
      # enable it running automatically.

      environment.systemPackages = [
        manage_script
      ];

    }

    (mkIf config.flyingcircus.agent.enable {

      systemd.timers.fc-manage = {
        description = "Timer for fc-manage";
        wantedBy = [ "timers.target" ];
        enable = true;
        timerConfig = {
          Unit = "fc-manage.service";
          # XXX This 10s thing is annoying. There seems to be an issue that
          # networking isn't _really_ up when the timer triggers for the
          # first time even though the 'network-online.target' is waited
          # for.
          OnBootSec = "10s";
          OnUnitActiveSec = "10m";
          # Not yet supported by our systemd version.
          # RandomSec = "3m";
        };
      };

      systemd.services.fc-manage = {
        description = "Flying Circus Management Task";
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;
        serviceConfig.Type = "oneshot";

        # This configuration is stolen from NixOS' own automatic updater.

        environment = config.nix.envVars // {
          inherit (config.environment.sessionVariables) NIX_PATH SSL_CERT_FILE;
          HOME = "/root";
        };
        script = "${manage_script}/bin/fc-manage ${config.flyingcircus.agent.steps}";
      };
    })

  ];

}
