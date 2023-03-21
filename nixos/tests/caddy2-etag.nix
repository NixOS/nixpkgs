import ./common/etag {
  name = "caddy2-etag";

  serverConfig = { config, pkgs, ... }: {
    services.caddy = {
      enable = true;
      virtualHosts."server:80".extraConfig = ''
        handle_path /symlink/* {
          root * ${config.test-support.etag.root}
          file_server
        }

        root * ${config.test-support.etag.root}
        file_server
      '';
    };
  };
}
