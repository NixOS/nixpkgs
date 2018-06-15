let
  commonConfig = { config, lib, pkgs, nodes, ... }: {
    networking.nameservers = [
      nodes.letsencrypt.config.networking.primaryIPAddress
    ];

    nixpkgs.overlays = lib.singleton (self: super: {
      cacert = super.cacert.overrideDerivation (drv: {
        installPhase = (drv.installPhase or "") + ''
          cat "${nodes.letsencrypt.config.test-support.letsencrypt.caCert}" \
            >> "$out/etc/ssl/certs/ca-bundle.crt"
        '';
      });

      pythonPackages = (super.python.override {
        packageOverrides = lib.const (pysuper: {
          certifi = pysuper.certifi.overridePythonAttrs (attrs: {
            postPatch = (attrs.postPatch or "") + ''
              cat "${self.cacert}/etc/ssl/certs/ca-bundle.crt" \
                > certifi/cacert.pem
            '';
          });
        });
      }).pkgs;
    });
  };

in import ./make-test.nix {
  name = "acme";

  nodes = {
    letsencrypt = ./common/letsencrypt.nix;

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
