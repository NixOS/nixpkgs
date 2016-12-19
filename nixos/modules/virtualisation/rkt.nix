{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.rkt;
in
{
  options.virtualisation.rkt = {
    enable = mkEnableOption "rkt metadata service";

    gc = {
      automatic = mkOption {
        default = true;
        type = types.bool;
        description = "Automatically run the garbage collector at a specific time.";
      };

      dates = mkOption {
        default = "03:15";
        type = types.str;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>) of the time at
          which the garbage collector will run.
        '';
      };

      options = mkOption {
        default = "--grace-period=24h";
        type = types.str;
        description = ''
          Options given to <filename>rkt gc</filename> when the
          garbage collector is run automatically.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.rkt ];

    systemd.services.rkt = {
      description = "rkt metadata service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.rkt}/bin/rkt metadata-service";
      };
    };

    systemd.services.rkt-gc = {
      description = "rkt garbage collection";
      startAt = optionalString cfg.gc.automatic cfg.gc.dates;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.rkt}/bin/rkt gc ${cfg.gc.options}";
      };
    };

    users.extraGroups.rkt = {};
  };
}
