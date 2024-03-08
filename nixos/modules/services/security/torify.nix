{ config, lib, pkgs, ... }:
with lib;
let

  cfg = config.services.tor;

  torify = pkgs.writeTextFile {
    name = "tsocks";
    text = ''
        #!${pkgs.runtimeShell}
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
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to build tsocks wrapper script to relay application traffic via Tor.

          ::: {.important}
          You shouldn't use this unless you know what you're
          doing because your installation of Tor already comes with
          its own superior (doesn't leak DNS queries)
          `torsocks` wrapper which does pretty much
          exactly the same thing as this.
          :::
        '';
      };

      server = mkOption {
        type = types.str;
        default = "localhost:9050";
        example = "192.168.0.20";
        description = lib.mdDoc ''
          IP address of TOR client to use.
        '';
      };

      config = mkOption {
        type = types.lines;
        default = "";
        description = lib.mdDoc ''
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
