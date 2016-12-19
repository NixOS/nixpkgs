{ config, lib, pkgs, ... }:
with lib;
let

  cfg = config.services.tor;

  torify = pkgs.writeTextFile {
    name = "tsocks";
    text = ''
        #!${pkgs.stdenv.shell}
        TSOCKS_CONF_FILE=${pkgs.writeText "tsocks.conf" cfg.tsocks.config} LD_PRELOAD="${pkgs.tsocks}/lib/libtsocks.so $LD_PRELOAD" "$@"
    '';
    executable = true;
    destination = "/bin/tsocks";
  };

in

{

  ###### interface
  
  options = {
  
    services.tor.tsocks = {

      enable = mkOption {
        default = cfg.enable && cfg.client.enable;
        description = ''
          Whether to build tsocks wrapper script to relay application traffic via TOR.
        '';
      };

      server = mkOption {
        default = "localhost:9050";
        example = "192.168.0.20";
        description = ''
          IP address of TOR client to use.
        '';
      };

      config = mkOption {
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to TSocks
          configuration file.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.tsocks.enable {

    environment.systemPackages = [ torify ];  # expose it to the users

    services.tor.tsocks.config = ''
      server = ${toString(head (splitString ":" cfg.tsocks.server))}
      server_port = ${toString(tail (splitString ":" cfg.tsocks.server))}

      local = 127.0.0.0/255.128.0.0
      local = 127.128.0.0/255.192.0.0
    '';
  };

}
