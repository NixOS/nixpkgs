{ config, lib, pkgs, ... }:

with lib;

let

  beatslib = import ./lib.nix { inherit lib pkgs; };

  mkMetricbeatConfig = cfg: {

    metricbeat.modules = cfg.modules;

  };

in
{
  options = {

    services.beats.metricbeat = beatslib.mkCommonOptions {
      name = "metricbeat";
      defaults = { package = pkgs.metricbeat; };
    } // {

      modules = mkOption {
        description = ''
          Modules Configuration.

          See <link xlink:hfref="https://github.com/elastic/beats/blob/master/metricbeat/metricbeat.reference.yml" />
        '';
        type = with types; listOf attrs;
        default = [];
      };

    };
  };

  config = beatslib.mkNixosConfig {
    mkBeatConfig = mkMetricbeatConfig;
    cfg = config.services.beats.metricbeat;
  };

}
