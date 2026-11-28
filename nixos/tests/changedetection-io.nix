{ lib, hostPkgs, ... }:
let
  port = 5000;

  # The browser images are only published for x86_64-linux.
  withBrowsers = hostPkgs.stdenv.hostPlatform.isx86_64;

  changedetectionConfig =
    { pkgs, ... }:
    {
      services.changedetection-io = {
        enable = true;
        inherit port;
      };

      # The website node has a private address, which is refused by default.
      systemd.services.changedetection-io.environment.ALLOW_IANA_RESTRICTED_ADDRESSES = "true";

      environment.systemPackages = [ pkgs.jq ];
    };

  browserConfig = {
    imports = [ changedetectionConfig ];
    virtualisation = {
      cores = 2;
      memorySize = 4096;
      diskSize = 8192;
    };
  };
in
{
  name = "changedetection-io";

  meta.maintainers = with lib.maintainers; [ thanegill ];

  nodes = {
    website = {
      services.nginx = {
        enable = true;
        virtualHosts.website.root = "/var/www";
      };
      networking.firewall.allowedTCPPorts = [ 80 ];
    };

    requests = changedetectionConfig;
  }
  // lib.optionalAttrs withBrowsers {
    playwright =
      { pkgs, ... }:
      {
        imports = [ browserConfig ];
        services.changedetection-io.playwrightSupport = true;

        # nix run nixpkgs#nix-prefetch-docker -- --image-name browserless/chrome --final-image-name docker.io/browserless/chrome
        # Prebooting starts a Chrome per allowed session, which a test VM can't afford.
        virtualisation.oci-containers.containers.changedetection-io-playwright.environment.PREBOOT_CHROME =
          lib.mkForce "false";

        virtualisation.oci-containers.containers.changedetection-io-playwright.imageFile =
          pkgs.dockerTools.pullImage
            {
              imageName = "browserless/chrome";
              imageDigest = "sha256:57d19e414d9fe4ae9d2ab12ba768c97f38d51246c5b31af55a009205c136012f";
              hash = "sha256-Or2XoaYtVBQKI6lYClk46dL97eKTpm8LAGTQxmmiTPc=";
              finalImageName = "docker.io/browserless/chrome";
              finalImageTag = "latest";
            };
      };

    webdriver =
      { pkgs, ... }:
      {
        imports = [ browserConfig ];
        services.changedetection-io.webDriverSupport = true;

        # nix run nixpkgs#nix-prefetch-docker -- --image-name selenium/standalone-chrome
        virtualisation.oci-containers.containers.changedetection-io-webdriver.imageFile =
          pkgs.dockerTools.pullImage
            {
              imageName = "selenium/standalone-chrome";
              imageDigest = "sha256:3fa985d1a73d1a3ae43c758d546b505b9d73e31ecaffd7a77725f19d1a70edec";
              hash = "sha256-J4VSx6aTSoWXyeeduKjz7cXMaTd9VlRJJAhzc510naY=";
              finalImageName = "selenium/standalone-chrome";
              finalImageTag = "latest";
            };
      };
  };

  testScript =
    { nodes, ... }:
    let
      inherit (nodes.requests.services.changedetection-io.package) version;
      api = "http://127.0.0.1:${toString port}/api/v1";
      websiteUrl = "http://${nodes.website.networking.primaryIPAddress}/";
    in
    ''
      import json
      import shlex

      def serve(text):
          # Only a fetcher that runs JavaScript sees the "rendered" suffix.
          html = (
              f"<html><body><p id='out'>{text}</p><script>"
              f"document.getElementById('out').textContent = '{text} rendered';"
              "</script></body></html>"
          )
          website.succeed(f"echo {shlex.quote(html)} > /var/www/index.html")

      def call_api(machine, path, data=None):
          command = f"curl -sSf -H @/tmp/api-header ${api}/{path}"
          if data is not None:
              command += " -H 'Content-Type: application/json' --data " + shlex.quote(json.dumps(data))
          return json.loads(machine.succeed(command))

      def wait_for_changedetection(machine):
          machine.wait_for_unit("changedetection-io.service")
          machine.wait_for_open_port(${toString port})
          machine.wait_until_succeeds("curl -sSf http://127.0.0.1:${toString port}/ | grep -F 'v${version}'")
          machine.succeed(
              "jq -r '\"x-api-key: \" + .settings.application.api_access_token' "
              "/var/lib/changedetection-io/changedetection.json > /tmp/api-header"
          )
          assert call_api(machine, "systeminfo")["version"] == "${version}"

      def wait_for_snapshot(machine, watch, text):
          # A recheck is dropped while the watch is still being fetched, so
          # keep asking until the snapshot shows up.
          machine.wait_until_succeeds(
              f"curl -sSf -H @/tmp/api-header ${api}/watch/{watch}?recheck=true > /dev/null"
              f" && curl -sSf -H @/tmp/api-header ${api}/watch/{watch}/history/latest"
              f" | grep -F {shlex.quote(text)}",
              timeout=600,
          )

      def check_detects_change(machine, fetch_backend, suffix):
          serve("first version")
          watch = call_api(machine, "watch", {"url": "${websiteUrl}", "fetch_backend": fetch_backend})["uuid"]
          wait_for_snapshot(machine, watch, "first version" + suffix)
          serve("second version")
          wait_for_snapshot(machine, watch, "second version" + suffix)
          assert len(call_api(machine, f"watch/{watch}/history")) >= 2
          return watch

      # One changedetection node at a time: loading a browser image and
      # running Chrome is heavy enough to starve concurrent VMs.
      website.succeed("mkdir -p /var/www")
      website.wait_for_open_port(80)

      with subtest("requests fetcher detects a change and keeps it across a restart"):
          wait_for_changedetection(requests)
          watch = check_detects_change(requests, "html_requests", "")
          requests.fail(f"curl -sSf -H @/tmp/api-header ${api}/watch/{watch}/history/latest | grep -F rendered")
          requests.systemctl("restart changedetection-io.service")
          wait_for_changedetection(requests)
          wait_for_snapshot(requests, watch, "second version")
          requests.shutdown()
    ''
    + lib.optionalString withBrowsers ''

      for machine, container in [(playwright, "playwright"), (webdriver, "webdriver")]:
          with subtest(f"{container} fetcher renders JavaScript and detects a change"):
              machine.wait_for_unit(f"podman-changedetection-io-{container}.service", timeout=1800)
              machine.wait_for_open_port(4444)
              wait_for_changedetection(machine)
              check_detects_change(machine, "html_webdriver", " rendered")
              machine.shutdown()
    '';
}
