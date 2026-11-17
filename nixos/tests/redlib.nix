{ lib, pkgs, ... }:
let
  certs = import redlib/snakeoil-certs.nix;
  redditDomain = certs.domain;
in
{
  name = "redlib";
  meta.maintainers = with lib.maintainers; [
    bpeetz
    Guanran928
  ];

  nodes.machine = {
    # The test will hang if Redlib can't initialize its OAuth client, so we
    # provide it with a mock endpoint.
    networking.hosts."127.0.0.1" = [ redditDomain ];
    security.pki.certificates = [
      (builtins.readFile certs.ca.cert)
    ];
    services.nginx = {
      enable = true;
      virtualHosts.${redditDomain} = {
        onlySSL = true;
        sslCertificate = certs.${redditDomain}.cert;
        sslCertificateKey = certs.${redditDomain}.key;
        locations."/auth/v2/oauth/access-token/loid".extraConfig = ''
          return 200 "{\"access_token\":\"AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\",\"expires_in\":0}";
        '';
      };
    };

    services.redlib = {
      package = pkgs.redlib;
      enable = true;
      # Test CAP_NET_BIND_SERVICE
      port = 80;

      settings = {
        REDLIB_DEFAULT_USE_HLS = true;
      };
    };
  };

  testScript = ''
    machine.wait_for_unit("redlib.service")
    machine.wait_for_open_port(80)
    # Query a page that does not require Internet access
    machine.succeed("curl --fail http://localhost:80/settings")
    machine.succeed("curl --fail http://localhost:80/info | grep '<tr><td>Use HLS</td><td>on</td></tr>'")
  '';
}
