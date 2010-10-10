{ config, pkgs, ... }:
with pkgs.lib;
let

  cfg = config.services.tor;

  torsocks = pkgs.writeTextFile {
    name = "torsocks";
    text = ''
        #!${pkgs.stdenv.shell}
        TORSOCKS_CONF_FILE=${pkgs.writeText "torsocks.conf" cfg.torsocks.config} LD_PRELOAD="${pkgs.torsocks}/lib/torsocks/libtorsocks.so $LD_PRELOAD" $@
    '';
    executable = true;
    destination = "/bin/torsocks";
  };

in

{

  ###### interface
  
  options = {
  
    services.tor.torsocks = {

      enable = mkOption {
        default = cfg.client.enable;
        description = ''
          Whether to build torsocks scipt to relay application traffic via TOR.
        '';
      };

      server = mkOption {
        default = cfg.client.socksListenAddress;
        example = "192.168.0.20";
        description = ''
          IP address of TOR client to use.
        '';
      };

      config = mkOption {
        default = "";
        description = ''
          Extra configuration. Contents will be added verbatim to torsocks
          configuration file.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf cfg.torsocks.enable {

    environment.systemPackages = [ torsocks ];  # expose it to the users

    services.tor.torsocks.config = ''
      server = ${toString(head (splitString ":" cfg.torsocks.server))}
      server_port = ${toString(tail (splitString ":" cfg.torsocks.server))}

      local = 127.0.0.0/255.128.0.0
      local = 127.128.0.0/255.192.0.0
      local = 169.254.0.0/255.255.0.0
      local = 172.16.0.0/255.240.0.0
      local = 192.168.0.0/255.255.0.0
    '';
  };

}
