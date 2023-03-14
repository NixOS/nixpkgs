{ config, pkgs, lib, ... }:

let

  cfg = config.services.quicktun;

in

with lib;

{
  options = {

    services.quicktun = mkOption {
      default = { };
      description = lib.mdDoc "QuickTun tunnels";
      type = types.attrsOf (types.submodule {
        options = {
          tunMode = mkOption {
            type = types.int;
            default = 0;
            example = 1;
            description = lib.mdDoc "";
          };

          remoteAddress = mkOption {
            type = types.str;
            example = "tunnel.example.com";
            description = lib.mdDoc "";
          };

          localAddress = mkOption {
            type = types.str;
            example = "0.0.0.0";
            description = lib.mdDoc "";
          };

          localPort = mkOption {
            type = types.int;
            default = 2998;
            description = lib.mdDoc "";
          };

          remotePort = mkOption {
            type = types.int;
            default = 2998;
            description = lib.mdDoc "";
          };

          remoteFloat = mkOption {
            type = types.int;
            default = 0;
            description = lib.mdDoc "";
          };

          protocol = mkOption {
            type = types.str;
            default = "nacltai";
            description = lib.mdDoc "";
          };

          privateKey = mkOption {
            type = types.str;
            description = lib.mdDoc "";
          };

          publicKey = mkOption {
            type = types.str;
            description = lib.mdDoc "";
          };

          timeWindow = mkOption {
            type = types.int;
            default = 5;
            description = lib.mdDoc "";
          };

          upScript = mkOption {
            type = types.lines;
            default = "";
            description = lib.mdDoc "";
          };
        };
      });
    };

  };

  config = mkIf (cfg != []) {
    systemd.services = foldr (a: b: a // b) {} (
      mapAttrsToList (name: qtcfg: {
        "quicktun-${name}" = {
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          environment = {
            INTERFACE = name;
            TUN_MODE = toString qtcfg.tunMode;
            REMOTE_ADDRESS = qtcfg.remoteAddress;
            LOCAL_ADDRESS = qtcfg.localAddress;
            LOCAL_PORT = toString qtcfg.localPort;
            REMOTE_PORT = toString qtcfg.remotePort;
            REMOTE_FLOAT = toString qtcfg.remoteFloat;
            PRIVATE_KEY = qtcfg.privateKey;
            PUBLIC_KEY = qtcfg.publicKey;
            TIME_WINDOW = toString qtcfg.timeWindow;
            TUN_UP_SCRIPT = pkgs.writeScript "quicktun-${name}-up.sh" qtcfg.upScript;
            SUID = "nobody";
          };
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.quicktun}/bin/quicktun.${qtcfg.protocol}";
          };
        };
      }) cfg
    );
  };

}
