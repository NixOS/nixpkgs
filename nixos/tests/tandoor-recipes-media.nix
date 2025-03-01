import ./make-test-python.nix (
  { ... }:
  {
    name = "tandoor-recipes";

    nodes.machine = {
      services.tandoor-recipes = {
        enable = true;
        # This setting is not recommended, but it's an easy way serve the media
        # folder in this test.
        extraConfig = {
          GUNICORN_MEDIA = true;
        };
      };

      specialisation.oldVersion.configuration = {
        system.stateVersion = "24.11";
      };
    };

    testScript =
      { nodes, ... }:
      let
        oldVersion = "${nodes.machine.system.build.toplevel}/specialisation/oldVersion";
      in
      # python
      ''
        def wait_for_tandoor():
          machine.wait_for_unit("tandoor-recipes.service")
          machine.wait_for_open_port(8080)


        db_path = "http://localhost:8080/media/db.sqlite3"


        # The media folder shouldn't contain the database. Subsequently it
        # should not get served, resulting in a 404.
        # Previously the database was located in the media folder. Therefore
        # serving the media folder would expose the database. See #338339.
        wait_for_tandoor()
        machine.succeed(f"curl --head {db_path} | grep \"HTTP/1.1 404 Not Found\"")


        # Switch to NixOS 24.11 to check if the setup still functions the same
        # as before.
        machine.succeed("${oldVersion}/bin/switch-to-configuration test")

        # With the old setup the media folder should contain the database.
        # Subsequently it should get served, resulting in a 200.
        wait_for_tandoor()
        machine.succeed(f"curl --head {db_path} | grep \"HTTP/1.1 200 OK\"")
      '';
  }
)
