{
  package,
  browser,
  image,
}:
{ lib, ... }:

let
  container = "changedetection-io-${browser}";
in
{
  name = container;

  meta.maintainers = [ lib.maintainers.davinci42 ];

  nodes = {
    website =
      { ... }:
      {
        services.nginx = {
          enable = true;
          virtualHosts.localhost.root = "/var/www";
        };
        networking.firewall.allowedTCPPorts = [ 80 ];
      };

    machine =
      { pkgs, ... }:
      {
        services.changedetection-io = {
          enable = true;
          inherit package;
          listenAddress = "127.0.0.1";
          playwrightSupport = browser == "playwright";
          webDriverSupport = browser == "webdriver";
        };

        systemd.services.changedetection-io.environment = {
          ALLOW_IANA_RESTRICTED_ADDRESSES = "true";
          DISABLE_VERSION_CHECK = "true";
        };

        virtualisation = {
          memorySize = 4096;
          cores = 2;
          diskSize = 12288;
          oci-containers.containers.${container}.imageFile = pkgs.dockerTools.pullImage image;
        };

        environment.systemPackages = [ pkgs.jq ];
      };
  };

  testScript = builtins.readFile ./helpers.py + ''
    def page(value):
        html = "<html><body><div id='result'>JavaScript required</div><script>document.getElementById('result').textContent = ['rendered', '" + value + "'].join(' ');</script></body></html>"
        website.succeed("mkdir -p /var/www; printf %s " + shlex.quote(html) + " > /var/www/index.html")

    start_all()

    try:
        with subtest("default browser container and service start"):
            page("original")
            website.wait_for_unit("nginx.service")
            machine.wait_for_unit("podman-${container}.service")
            machine.wait_for_open_port(4444)
            wait_for_service(machine, "${package.version}")
            info = json.loads(machine.succeed("podman inspect ${container}"))[0]
            assert info["State"]["Running"]
            print("Browser image:", info["ImageName"])

        with subtest("browser renders JavaScript and detects changed content"):
            address = machine.succeed("getent ahostsv4 website | cut -d ' ' -f 1 | sort -u").strip()
            url = f"http://{address}/"
            machine.succeed("curl --fail --silent " + shlex.quote(url) + " | grep -F 'JavaScript required'")
            machine.fail("curl --fail --silent " + shlex.quote(url) + " | grep -F 'rendered original'")
            watch = json.loads(api(machine, "watch", {
                "url": url,
                "fetch_backend": "html_webdriver",
                "title": "Browser test",
            }))["uuid"]
            api(machine, f"watch/{watch}?recheck=true")
            wait_for_snapshot(machine, watch, "rendered original", timeout=180)
            machine.succeed(f"test -s /var/lib/changedetection-io/{watch}/last-screenshot.png")
            machine.sleep(2)
            page("updated")
            api(machine, f"watch/{watch}?recheck=true")
            wait_for_snapshot(machine, watch, "rendered updated", timeout=180)
            assert len(json.loads(api(machine, f"watch/{watch}/history"))) >= 2
            assert not json.loads(api(machine, f"watch/{watch}"))["last_error"]
    finally:
        print(machine.execute("journalctl -u changedetection-io.service -u podman-${container}.service --no-pager")[1])
        print(machine.execute("podman logs ${container}")[1])
  '';
}
