{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.brltty;

  targets = [
    "default.target" "multi-user.target"
    "rescue.target" "emergency.target"
  ];

  genApiKey = pkgs.writers.writeDash "generate-brlapi-key" ''
    if ! test -f /etc/brlapi.key; then
      echo -n generating brlapi key...
      ${pkgs.brltty}/bin/brltty-genkey -f /etc/brlapi.key
      echo done
    fi
  '';

in {

  options = {

    services.brltty.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Whether to enable the BRLTTY daemon.";
    };

  };

  config = mkIf cfg.enable {
    users.users.brltty = {
      description = "BRLTTY daemon user";
      group = "brltty";
    };
    users.groups = {
      brltty = { };
      brlapi = { };
    };

    systemd.services."brltty@".serviceConfig =
      { ExecStartPre = "!${genApiKey}"; };

    # Install all upstream-provided files
    systemd.packages = [ pkgs.brltty ];
    systemd.tmpfiles.packages = [ pkgs.brltty ];
    services.udev.packages = [ pkgs.brltty ];
    environment.systemPackages = [ pkgs.brltty ];

    # Add missing WantedBys (see issue #81138)
    systemd.paths.brltty.wantedBy = targets;
    systemd.paths."brltty@".wantedBy = targets;
  };

}
