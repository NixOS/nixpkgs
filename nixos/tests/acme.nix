let
  commonConfig = ./common/letsencrypt/common.nix;
in import ./make-test.nix {
  name = "acme";

  nodes = {
    letsencrypt = ./common/letsencrypt;

    webserver = { config, pkgs, ... }: {
      imports = [ commonConfig ];
      networking.firewall.allowedTCPPorts = [ 80 443 ];

      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} example.com
      '';

      services.nginx.enable = true;
      services.nginx.virtualHosts."example.com" = {
        enableACME = true;
        forceSSL = true;
        locations."/".root = pkgs.runCommand "docroot" {} ''
          mkdir -p "$out"
          echo hello world > "$out/index.html"
        '';
      };
    };

    client = commonConfig;
  };

  testScript = ''
    $letsencrypt->waitForUnit("default.target");
    $letsencrypt->waitForUnit("boulder.service");
    $webserver->waitForUnit("default.target");
    $webserver->waitForUnit("acme-certificates.target");
    $client->waitForUnit("default.target");
    $client->succeed('curl https://example.com/ | grep -qF "hello world"');
  '';
}
