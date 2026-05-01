{
  pkgs,
  ...
}:

{
  name = "strichliste";
  meta.maintainers = pkgs.strichliste.meta.maintainers;

  nodes = {
    server =
      { config, ... }:
      {
        networking.extraHosts = ''
          127.0.0.1 strichliste.local
        '';

        environment.systemPackages = with pkgs; [ httpie ];

        time.timeZone = "Europe/Berlin";

        services.strichliste = {
          enable = true;
          domain = "strichliste.local";
          environmentFiles = [
            (pkgs.writeText "strichliste-secret.env" ''
              APP_SECRET=changemechangemechangeme
            '')
          ];
          settings = {
            i18n = {
              currency = {
                alpha3 = "EUR";
                name = "Euro";
                symbol = "€";
              };
            };
          };
        };
      };
  };

  testScript =
    {
      nodes,
      ...
    }:
    # python
    ''
      import json

      start_all()

      def get_users():
        response = machine.succeed("http --check-status http://strichliste.local/api/user")
        users = json.loads(response)["users"]
        return users

      def get_user(uid: int):
        response = machine.succeed(f"http --check-status http://strichliste.local/api/user/{uid}")
        user = json.loads(response)["user"]
        return user

      def test():
        with subtest("Check empty user list"):
          users = get_users()
          t.assertEqual(len(users), 0, "Strichliste must not have users.")

        with subtest("Create user"):
          machine.succeed("http --check-status post http://strichliste.local/api/user name=Alice")
          users = get_users()
          t.assertEqual(len(users), 1, "Strichliste must have exactly one user.")

        with subtest("Retrieve user details"):
          user = get_user(1)
          t.assertEqual(user["name"], "Alice", "Created user must be named Alice")
          t.assertEqual(user["balance"], 0, "New users should have a balance of 0")

        with subtest("Deposit money"):
          machine.succeed("http --check-status post http://strichliste.local/api/user/1/transaction amount=500")
          user = get_user(1)
          t.assertEqual(user["balance"], 500, "Balance must be 500 after depositing 500")

        with subtest("Dispense money"):
          machine.succeed("http --check-status post http://strichliste.local/api/user/1/transaction amount=-1000")
          user = get_user(1)
          t.assertEqual(user["balance"], -500, "Balance must be -500 after dispensing 1000")

        with subtest("Undo transaction"):
          response = machine.succeed("http --check-status post http://strichliste.local/api/user/1/transaction amount=7500")
          transaction = json.loads(response)["transaction"]
          machine.succeed(f"http --check-status delete http://strichliste.local/api/user/1/transaction/{transaction['id']}")

      server.wait_for_unit("phpfpm-strichliste.service")

      # frontend
      server.wait_until_succeeds("http --check-status http://strichliste.local/ | grep -q '<title>Strichliste</title>'")

      # backend
      server.wait_until_succeeds("http --check-status http://strichliste.local/api/settings")

      # sqlite
      test()
    '';
}
