{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.pacemaker;
in
{
  # interface
  options.services.pacemaker = {
    enable = mkEnableOption "pacemaker";

    package = mkOption {
      type = types.package;
      default = pkgs.pacemaker;
      defaultText = literalExpression "pkgs.pacemaker";
      description = lib.mdDoc "Package that should be used for pacemaker.";
    };
  };

  # implementation
  config = mkIf cfg.enable {
    assertions = [ {
      assertion = config.services.corosync.enable;
      message = ''
        Enabling services.pacemaker requires a services.corosync configuration.
      '';
    } ];

    environment.systemPackages = [ cfg.package ];

    # required by pacemaker
    users.users.hacluster = {
      isSystemUser = true;
      group = "pacemaker";
      home = "/var/lib/pacemaker";
    };
    users.groups.pacemaker = {};

    systemd.tmpfiles.rules = [
      "d /var/log/pacemaker 0700 hacluster pacemaker -"
    ];

    systemd.packages = [ cfg.package ];
    systemd.services.pacemaker = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        StateDirectory = "pacemaker";
        StateDirectoryMode = "0700";
      };
    };
  };
}
