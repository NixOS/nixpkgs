import ./make-test-python.nix ({ pkgs, lib, ... }:
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
rec {
  name = "hledger-web";
  meta.maintainers = with lib.maintainers; [ marijanp ];

  nodes = {
    server = { config, pkgs, ... }: rec {
      services.hledger-web = {
        host = "127.0.0.1";
        port = 5000;
        enable = true;
        journalFile = journal;
      };
      networking.firewall.allowedTCPPorts = [ services.hledger-web.port ];
    };
    apiserver = { config, pkgs, ... }: rec {
      services.hledger-web = {
        host = "127.0.0.1";
        port = 5000;
        enable = true;
        serveApi = true;
        journalFile = journal;
      };
      networking.firewall.allowedTCPPorts = [ services.hledger-web.port ];
    };
  };

  testScript = ''
    start_all()

    server.wait_for_unit("hledger-web.service")
    server.wait_for_open_port(5000)
    with subtest("Check if web UI is accessible"):
        page = server.succeed("curl -L http://127.0.0.1:5000")
        assert "test.journal" in page

    apiserver.wait_for_unit("hledger-web.service")
    apiserver.wait_for_open_port(5000)
    with subtest("Check if the JSON API is served"):
        transactions = apiserver.succeed("curl -L http://127.0.0.1:5000/transactions")
        assert "NixOS Foundation donation" in transactions
  '';
})
