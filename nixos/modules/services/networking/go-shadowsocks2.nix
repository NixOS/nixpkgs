{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.go-shadowsocks2.server;
in
{
  options.services.go-shadowsocks2.server = {
    enable = lib.mkEnableOption "go-shadowsocks2 server";

    listenAddress = lib.mkOption {
      type = lib.types.str;
      description = "Server listen address or URL";
      example = "ss://AEAD_CHACHA20_POLY1305:your-password@:8488";
    };
  };

  config = lib.mkIf cfg.enable {
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
