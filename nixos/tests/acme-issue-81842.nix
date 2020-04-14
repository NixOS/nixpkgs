# When nginx depends on a service that is slow to start up, requesting
# certificates fail.  Reproducer for
# https://github.com/NixOS/nixpkgs/issues/81842
import ./make-test-python.nix {
  name = "acme-issue-81842";
  nodes = {
    letsencrypt = { nodes, lib, ... }: {
      imports = [ ./common/letsencrypt ];
      # TODO: Move out to common ?
    };
    webserver = { nodes, config, pkgs, lib, ... }: {
      imports = [ ./common/letsencrypt/common.nix ];

      # TODO move to common?
      security.acme.server = "https://acme-v02.api.letsencrypt.org/dir";

      systemd.services.my-slow-service = {
        wantedBy = [ "multi-user.target" "nginx.service" ];
        before = [ "nginx.service" ];
        preStart = "sleep 5";
        script = "${pkgs.python3}/bin/python -m http.server";
      };

      # Probe to measure that acme-a.example.com.service fired
      systemd.targets."acme-finished-a.example.com" = {
        after = [ "acme-a.example.com.service" ];
        wantedBy = [ "acme-a.example.com.service" ];
      };

      # TODO: Move to pebble dns server. get rid of the resolver.nix hacks
      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} a.example.com
      '';


      networking.firewall.allowedTCPPorts = [ 80 443 ];

      services.nginx = {
        enable = true;
        virtualHosts."a.example.com" = {
          forceSSL = true;
          enableACME = true;
          locations."/".proxyPass = "http://localhost:8000";
        };
      };
    };
    client = { nodes, ... }: { imports = [ ./common/letsencrypt/common.nix ]; };
  };
  testScript = { nodes, ... }:
    ''
      letsencrypt.wait_for_unit("default.target")
      letsencrypt.wait_for_unit("pebble.service")
      client.wait_for_unit("default.target")
      client.succeed("curl https://acme-v02.api.letsencrypt.org:15000/roots/0 > /tmp/ca.crt")
      client.succeed(
          "curl https://acme-v02.api.letsencrypt.org:15000/intermediate-keys/0 >> /tmp/ca.crt"
      )
      webserver.wait_for_unit("acme-finished-a.example.com.target")
      client.succeed("curl --cacert /tmp/ca.crt https://a.example.com/")
    '';
}
