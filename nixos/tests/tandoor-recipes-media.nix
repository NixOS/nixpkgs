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
    };

    testScript = # python
      ''
        machine.wait_for_unit("tandoor-recipes.service")
        machine.wait_for_open_port(8080)

        # The media folder shouldn't contain the database. Subsequently it should
        # not get served, resulting in a 404.
        # Previously the database was located in the media folder. Therefore
        # serving the media folder would expose the database. See #338339.
        machine.succeed("curl --head http://localhost:8080/media/db.sqlite3 | grep \"HTTP/1.1 404 Not Found\"")
      '';
  }
)
