import ./make-test-python.nix (
  { pkgs, ... }:

  let
    # In a real deployment this should naturally not common from the nix store
    # and be seeded via agenix or as a non-nix managed file.
    #
    # These credentials are from the nitter wiki and are expired. We must provide
    # credentials in the correct format, otherwise nitter fails to start. They
    # must not be valid, as unauthorized errors are handled gracefully.
    guestAccountFile = pkgs.writeText "guest_accounts.jsonl" ''
      {"oauth_token":"1719213587296620928-BsXY2RIJEw7fjxoNwbBemgjJhueK0m","oauth_token_secret":"N0WB0xhL4ng6WTN44aZO82SUJjz7ssI3hHez2CUhTiYqy"}
    '';
  in
  {
    name = "nitter";
    meta.maintainers = with pkgs.lib.maintainers; [ erdnaxe ];

    nodes.machine = {
      services.nitter = {
        enable = true;
        # Test CAP_NET_BIND_SERVICE
        server.port = 80;
        # Provide dummy guest accounts
        guestAccounts = guestAccountFile;
      };
    };

    testScript = ''
      machine.wait_for_unit("nitter.service")
      machine.wait_for_open_port(80)
      machine.succeed("curl --fail http://localhost:80/")
    '';
  }
)
