import ./common/etag {
  name = "caddy2-etag";

  serverConfig = { config, pkgs, ... }: {
    systemd.services.caddy2 = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.caddy2}/bin/caddy file-server -listen :80 -root ${config.test-support.etag.root}";
      };
    };
  };
}
