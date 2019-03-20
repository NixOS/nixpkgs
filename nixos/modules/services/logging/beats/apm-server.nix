{ config, lib, pkgs, ... }:

with lib;

let

  beatslib = import ./lib.nix { inherit lib pkgs; };

  mkApmServerConfig = cfg: {

    apm-server.host = "${cfg.listenAddress}:${toString cfg.port}";

  };


in

{
  ###### interface

  options = {

    services.beats.apm-server = recursiveUpdate
      (beatslib.mkCommonOptions { name = "apm-server"; defaults = { package = pkgs.elastic-apm-server; }; })
      {

        listenAddress = mkOption {
          description = "Address on which to listen.";
          type = types.str;
          default = "localhost";
        };

        port = mkOption {
          description = "Port on which to listen.";
          type = types.int;
          default = 8200;
        };

        elasticsearch.indices = mkOption {
          description = "Array of index selector rules";
          type = with types; listOf attrs;
          default = [
            {
              index = "apm-%{[beat.version]}-sourcemap";
              when.contains.processor.event = "sourcemap";
            }
            {
              index = "apm-%{[beat.version]}-error-%{+yyyy.MM.dd}";
              when.contains.processor.event = "error";
            }
            {
              index = "apm-%{[beat.version]}-transaction-%{+yyyy.MM.dd}";
              when.contains.processor.event = "transaction";
            }
            {
              index = "apm-%{[beat.version]}-span-%{+yyyy.MM.dd}";
              when.contains.processor.event = "span";
            }
            {
              index = "apm-%{[beat.version]}-metric-%{+yyyy.MM.dd}";
              when.contains.processor.event = "metric";
            }
            {
              index = "apm-%{[beat.version]}-onboarding-%{+yyyy.MM.dd}";
              when.contains.processor.event = "onboarding";
            }
          ];
        };

      };

  };

  config = beatslib.mkNixosConfig {
    mkBeatConfig = mkApmServerConfig;
    cfg = config.services.beats.apm-server;
  };

}
