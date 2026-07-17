{
  config,
  lib,
  pkgs,
  ...
}:
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

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
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

      server = lib.mkOption {
        type = lib.types.str;
        default = "localhost:9050";
        example = "192.168.0.20";
        description = ''
          IP address of TOR client to use.
        '';
      };

      config = lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to TSocks
          configuration file.
        '';
      };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.tsocks.enable {

    environment.systemPackages = [ torify ]; # expose it to the users

    services.tor.tsocks.config = ''
      server = ${toString (lib.head (lib.splitString ":" cfg.tsocks.server))}
      server_port = ${toString (lib.tail (lib.splitString ":" cfg.tsocks.server))}

      local = 127.0.0.0/255.128.0.0
      local = 127.128.0.0/255.192.0.0
    '';
  };

}
