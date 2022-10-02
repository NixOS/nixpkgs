{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.go-shadowsocks2.server;
in {
  options.services.go-shadowsocks2.server = {
    enable = mkEnableOption (lib.mdDoc "go-shadowsocks2 server");

    listenAddress = mkOption {
      type = types.str;
      description = lib.mdDoc "Server listen address or URL";
      example = "ss://AEAD_CHACHA20_POLY1305:your-password@:8488";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.go-shadowsocks2-server = {
      description = "go-shadowsocks2 server";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.go-shadowsocks2}/bin/go-shadowsocks2 -s '${cfg.listenAddress}'";
        DynamicUser = true;
      };
    };
  };
}
