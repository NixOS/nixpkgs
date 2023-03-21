import ./common/etag {
  name = "nginx-etag";

  serverConfig = { config, ... }: {
    services.nginx = {
      enable = true;
      virtualHosts.server = {
        root = config.test-support.etag.root;
        locations."/symlink/".alias = "/var/www/";
      };
    };
  };
}
