import ./make-test.nix {
  name = "zabbix-proxy";

  nodes = {
    proxy =
      { pkgs, ... }:

      {
        services.zabbixProxy.enable = true;
      };
  };

  testScript = ''
    startAll;

    $proxy->waitForUnit("zabbix-proxy.service");
    $proxy->waitForFile("/run/zabbix/zabbix_proxy.pid");
    $proxy->waitUntilSucceeds("curl -L localhost:10051 | grep OK");
  '';
}
