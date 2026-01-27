{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

{
  options = {
    services.toxvpn = {
      enable = mkEnableOption "toxvpn running on startup";

      localip = mkOption {
        type = types.str;
        default = "10.123.123.1";
        description = "your ip on the vpn";
      };

      port = mkOption {
        type = types.port;
        default = 33445;
        description = "udp port for toxcore, port-forward to help with connectivity if you run many nodes behind one NAT";
      };

      auto_add_peers = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [
          "toxid1"
          "toxid2"
        ];
        description = "peers to automatically connect to on startup";
      };
    };
  };

  config = mkIf config.services.toxvpn.enable {
    systemd.services.toxvpn = {
      description = "toxvpn daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        ExecStart =
          let
            args = lib.cli.toCommandLineShellGNU { } {
              i = config.services.toxvpn.localip;
              l = "/run/toxvpn/control";
              u = "toxvpn";
              p = config.services.toxvpn.port;
              a = config.services.toxvpn.auto_add_peers;
            };
          in
          "${lib.getExe pkgs.toxvpn} ${args}";
        RuntimeDirectory = "toxvpn";
        KillMode = "process";
        Restart = "on-success";
        Type = "notify";
      };

      restartIfChanged = false; # Likely to be used for remote admin
    };

    environment.systemPackages = [ pkgs.toxvpn ];

    users.users = {
      toxvpn = {
        isSystemUser = true;
        group = "toxvpn";
        home = "/var/lib/toxvpn";
        createHome = true;
      };
    };
    users.groups.toxvpn = { };
  };
}
