{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.nix.gc;
in

{

  ###### interface

  options = {

    nix.gc = {

      automatic = mkOption {
        default = false;
        type = types.bool;
        description = "Automatically run the garbage collector at a specific time.";
      };

      dates = mkOption {
        default = "03:15";
        type = types.uniq types.string;
        description = ''
          Specification (in the format described by
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>5</manvolnum></citerefentry>) of the time at
          which the garbage collector will run.
        '';
      };

      options = mkOption {
        default = "";
        example = "--max-freed $((64 * 1024**3))";
        type = types.uniq types.string;
        description = ''
          Options given to <filename>nix-collect-garbage</filename> when the
          garbage collector is run automatically.
        '';
      };

    };

  };


  ###### implementation

  config = {

    systemd.services.nix-gc =
      { description = "Nix Garbage Collector";
        script = "exec ${config.nix.package}/bin/nix-collect-garbage ${cfg.options}";
        startAt = optionalString cfg.automatic cfg.dates;
      };

  };

}
