{ config, pkgs, ... }:
with pkgs.lib;
let

  cfg = config.services.tor;

  makeConfig = server: ''
      server = ${toString(head (splitString ":" server))}
      server_port = ${toString(tail (splitString ":" server))}

      local = 127.0.0.0/255.128.0.0
      local = 127.128.0.0/255.192.0.0
      local = 169.254.0.0/255.255.0.0
      local = 172.16.0.0/255.240.0.0
      local = 192.168.0.0/255.255.0.0

      ${cfg.torsocks.config}
    '';
  makeTorsocks = name: server: pkgs.writeTextFile {
    name = name;
    text = ''
        #!${pkgs.stdenv.shell}
        TORSOCKS_CONF_FILE=${pkgs.writeText "torsocks.conf" (makeConfig server)} LD_PRELOAD="${pkgs.torsocks}/lib/torsocks/libtorsocks.so $LD_PRELOAD" "$@"
    '';
    executable = true;
    destination = "/bin/${name}";
  };

  torsocks = makeTorsocks "torsocks" cfg.torsocks.server;
  torsocksFaster = makeTorsocks "torsocks-faster" cfg.torsocks.serverFaster;
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
        example = "192.168.0.20:9050";
        description = ''
          IP address of TOR client to use.
        '';
      };

      serverFaster = mkOption {
        default = cfg.client.socksListenAddressFaster;
        example = "192.168.0.20:9063";
        description = ''
          IP address of TOR client to use for applications like web browsers which
	  need less circuit isolation to achive satisfactory performance.
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

    environment.systemPackages = [ torsocks torsocksFaster ];  # expose it to the users

  };

}
