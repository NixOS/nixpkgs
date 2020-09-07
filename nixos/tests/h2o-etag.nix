import ./common/etag {
  name = "h2o-etag";

  serverConfig = { config, pkgs, ... }: let
    h2oConfig = pkgs.writeText "h2o.conf" (builtins.toJSON {
      listen.port = 80;
      hosts.server.paths."/"."file.dir" = config.test-support.etag.root;
    });
  in {
    systemd.services.h2o = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.h2o}/bin/h2o --conf ${h2oConfig}";
      };
    };
  };
}
