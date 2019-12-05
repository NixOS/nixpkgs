{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.syncthing;
in {
  ###### interface

  options.services.nebula = {
    enable = mkEnableOption "nebula - a scalable overlay networking tool";

    lighthouse = mkEnableOption "lighthouse functionality";

    nodes = mkOption {
      example = {
        lighthouse1 = { ip = "192.168.100.1/24"; };
        laptop = {
          ip = "192.168.100.2/24";
          groups = [ "laptop" "home" "ssh" ];
        };
        server1 = {
          ip = "192.168.100.9/24";
          groups = [ "servers" ];
        };
      };
    };

    config = mkOption {
      type = types.attrs;
      description = "TODO";
    };

    #   config = let
    #     pki = {
    #       options = {
    #         ca = mkOption {
    #           type = types.path;
    #           example = /etc/nebula/ca.crt;
    #         };
    #         cert = mkOption {
    #           type = types.path;
    #           example = /etc/nebula/host.crt;
    #         };
    #         key = mkOption {
    #           type = types.path;
    #           example = /etc/nebula/host.key;
    #         };
    #         blacklist = mkOption {
    #           default = [ ];
    #           type = with types; listOf str;
    #           example = [
    #             "c99d4e650533b92061b09918e838a5a0a6aaee21eed1d12fd937682865936c72"
    #           ];
    #         };
    #       };
    #     };
    #     lighthouse = {
    #       options = {
    #         am_lighthouse = mkOption {
    #           default = false;
    #           type = types.bool;
    #         };
    #         serve_dns = mkOption {
    #           default = false;
    #           type = types.bool;
    #         };
    #         interval = mkOption {
    #           default = 60;
    #           types = types.int;
    #         };
    #         hosts = mkOption {
    #           default = [ ];
    #           type = with types; listOf str;
    #         };
    #       };
    #     };
    #     listen = {
    #       options = {
    #         host = mkOption {
    #           default = "0.0.0.0";
    #           type = types.str;
    #         };
    #         port = mkOption {
    #           default = 4242;
    #           type = types.port;
    #         };
    #         batch = mkOption {
    #           default = 64;
    #           types = types.int;
    #         };
    #         read_buffer = mkOption {
    #           default = 10 * 1024 * 1024; # 10 Mb
    #           type = types.int;
    #         };
    #         write_buffer = mkOption {
    #           default = 10 * 1024 * 1024; # 10 Mb
    #           type = types.int;
    #         };
    #       };
    #     };
    #   in mkOption {
    #     type = types.submodule {
    #       options = {
    #         pki = mkOption {
    #           type = types.submodule pki;
    #           description = "Defines the location of credentials for this node.";
    #         };
    #         static_host_map = mkOption {
    #           type = with types; attrsOf (listOf str);
    #           example = { "192.168.100.1" = [ "100.64.22.11:4242" ]; };
    #         };
    #         lighthouse = mkOption {
    #           type = types.submodule lighthouse;
    #           description = "TODO";
    #         };
    #         listen = mkOption {
    #           type = types.submodule listen;
    #           description = "TODO";
    #         };
    #         punchy = mkOption {
    #           default = true;
    #           type = types.bool;
    #         };
    #       };
    #     };
    #     description = "Contents of config.yml";
    #   };

  };

  ###### implementation

  config = mkIf cfg.enable {
    assertions = [{
      assertion = cfg.config.lighthouse.am_lighthouse
        -> cfg.config.lighthouse.hosts == [ ];
      message = "TODO";
    }];

    systemd.packages = [ pkgs.nebula ];

    systemd.services.nebula = mkIf cfg.systemService {
      description = "Nebula service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Restart = "on-failure";
        ExecStart = ''
          ${pkgs.nebula}/bin/nebula -config ${configPath}
        '';
      };
    };
  };
}
