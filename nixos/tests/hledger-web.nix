{ pkgs, lib, ... }:
let
  journal = pkgs.writeText "test.journal" ''
    2010/01/10 Loan
        assets:cash                 500$
        income:loan                -500$
    2010/01/10 NixOS Foundation donation
        expenses:donation           250$
        assets:cash                -250$
  '';
in
{
  name = "hledger-web";
  meta.maintainers = with lib.maintainers; [ marijanp ];

  nodes = rec {
    server =
      { config, pkgs, ... }:
      {
        services.hledger-web = {
          host = "127.0.0.1";
          port = 5000;
          enable = true;
          allow = "edit";
        };
        networking.firewall.allowedTCPPorts = [ config.services.hledger-web.port ];
        systemd.services.hledger-web.preStart = ''
          ln -s ${journal} /var/lib/hledger-web/.hledger.journal
        '';
      };
    apiserver =
      { ... }:
      {
        imports = [ server ];
        services.hledger-web.serveApi = true;
      };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("hledger-web.service")
    server.wait_for_open_port(5000)
    with subtest("Check if web UI is accessible"):
        page = server.succeed("curl -L http://127.0.0.1:5000")
        assert ".hledger.journal" in page

    apiserver.wait_for_unit("hledger-web.service")
    apiserver.wait_for_open_port(5000)
    with subtest("Check if the JSON API is served"):
        transactions = apiserver.succeed("curl -L http://127.0.0.1:5000/transactions")
        assert "NixOS Foundation donation" in transactions
  '';
}
