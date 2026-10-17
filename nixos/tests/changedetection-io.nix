{ lib, pkgs, ... }:
let

  port = 5000;
  version = pkgs.changedetection-io.version;

  commonConfig =
    { ... }:
    {
      networking.firewall.allowedTCPPorts = [ port ];

      services.changedetection-io = {
        enable = true;
        listenAddress = "0.0.0.0";
        inherit port;
      };
    };

  commonConfigOCI =
    { ... }:
    {
      imports = [ commonConfig ];
      virtualisation = {
        cores = 2;
        memorySize = 2048;
        diskSize = 8192;
      };

      virtualisation.oci-containers.backend = "docker";
    };

in
{
  name = "changedetection-io";

  meta = {
    maintainers = with lib.maintainers; [ thanegill ];
    # Docker images only available for x86_64-linux
    broken = pkgs.stdenv.hostPlatform.isAarch64;
  };

  nodes = {
    client =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
      };

    changedetection-io-base =
      { ... }:
      {
        imports = [ commonConfig ];
      };

    changedetection-io-playwright =
      { ... }:
      {
        imports = [ commonConfigOCI ];

        services.changedetection-io.playwrightSupport = true;

        # To generate/update run: nix run nixpkgs#nix-prefetch-docker -- --image-name browserless/chrome
        virtualisation.oci-containers.containers.changedetection-io-playwright.imageFile =
          pkgs.dockerTools.pullImage
            {
              imageName = "browserless/chrome";
              imageDigest = "sha256:57d19e414d9fe4ae9d2ab12ba768c97f38d51246c5b31af55a009205c136012f";
              hash = "sha256-Or2XoaYtVBQKI6lYClk46dL97eKTpm8LAGTQxmmiTPc=";
              finalImageName = "browserless/chrome";
              finalImageTag = "latest";
            };
      };

    changedetechtion-io-webdriver =
      { ... }:
      {
        imports = [ commonConfigOCI ];

        services.changedetection-io.webDriverSupport = true;

        # To generate/update run: nix run nixpkgs#nix-prefetch-docker -- --image-name selenium/standalone-chrome
        virtualisation.oci-containers.containers.changedetection-io-webdriver.imageFile =
          pkgs.dockerTools.pullImage
            {
              imageName = "selenium/standalone-chrome";
              imageDigest = "sha256:aae9b4477f2c1af57c0d7c7e3711211d2287ceb865b9ec8d0b59c6c2a83416a5";
              hash = "sha256-qIFmZXb3Bx4eQD9ymIdmGNny5aNFG1QbcyGN0EENzhY=";
              finalImageName = "selenium/standalone-chrome";
              finalImageTag = "latest";
            };
      };

  };

  testScript = ''
    def client_curl_for_version(machine):
      client.wait_for_unit("multi-user.target")
      client.wait_until_succeeds(f"curl -sSf 'http://{machine.name}:${toString port}/' | grep 'v${version}'")

    def wait_until_changedetection_in_running(machine):
      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("changedetection-io")
      machine.wait_for_open_port(${toString port})

    start_all()

    wait_until_changedetection_in_running(changedetection-io-base)
    client_curl_for_version(changedetection-io-base)

    wait_until_changedetection_in_running(changedetection-io-playwright)
    changedetection-io-playwright.wait_for_unit("docker-changedetection-io-playwright")
    client_curl_for_version(changedetection-io-playwright)

    wait_until_changedetection_in_running(changedetechtion-io-webdriver)
    changedetechtion-io-webdriver.wait_for_unit("docker-changedetection-io-webdriver")
    client_curl_for_version(changedetection-io-playwright)
  '';
}
