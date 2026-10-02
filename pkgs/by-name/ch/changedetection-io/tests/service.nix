{ package }:
{ lib, ... }:

{
  name = "changedetection-io";

  meta.maintainers = [ lib.maintainers.davinci42 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.changedetection-io = {
        enable = true;
        inherit package;
        listenAddress = "127.0.0.1";
      };

      systemd.services.changedetection-io.environment = {
        ALLOW_IANA_RESTRICTED_ADDRESSES = "true";
        DISABLE_VERSION_CHECK = "true";
      };

      services.nginx = {
        enable = true;
        virtualHosts.localhost = {
          listen = [
            {
              addr = "127.0.0.1";
              port = 8080;
            }
          ];
          root = "/var/www";
        };
      };

      environment.systemPackages = [ pkgs.jq ];
      virtualisation.memorySize = 2048;
    };

  testScript = builtins.readFile ./helpers.py + ''
    start_all()

    try:
        with subtest("service starts and serves the web interface"):
            machine.succeed("mkdir -p /var/www; printf '<html><body>original content</body></html>' > /var/www/index.html")
            machine.wait_for_unit("nginx.service")
            wait_for_service(machine, "${package.version}")
            assert json.loads(api(machine, "systeminfo"))["version"] == "${package.version}"
            machine.succeed("test $(curl --silent --output /dev/null --write-out '%{http_code}' http://127.0.0.1:5000/api/v1/watch) = 403")

        with subtest("fetch a page and detect changed content"):
            watch = json.loads(api(machine, "watch", {
                "url": "http://127.0.0.1:8080/",
                "fetch_backend": "html_requests",
                "title": "NixOS test",
            }))["uuid"]
            api(machine, f"watch/{watch}?recheck=true")
            wait_for_snapshot(machine, watch, "original content")
            machine.succeed("sleep 2; printf '<html><body>updated content</body></html>' > /var/www/index.html")
            api(machine, f"watch/{watch}?recheck=true")
            wait_for_snapshot(machine, watch, "updated content")
            assert len(json.loads(api(machine, f"watch/{watch}/history"))) >= 2

        with subtest("watch and history survive a service restart"):
            machine.succeed("systemctl restart changedetection-io.service")
            machine.wait_for_unit("changedetection-io.service")
            machine.wait_for_open_port(5000)
            wait_for_snapshot(machine, watch, "updated content")
            assert json.loads(api(machine, f"watch/{watch}"))["title"] == "NixOS test"
            assert len(json.loads(api(machine, f"watch/{watch}/history"))) >= 2
    finally:
        print(machine.execute("journalctl -u changedetection-io.service --no-pager")[1])
  '';
}
