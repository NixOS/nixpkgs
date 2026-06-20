{ ... }:
{
  name = "tandoor-recipes-media";

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
      system.stateVersion = "25.11";
      services.tandoor-recipes = {
        enable = true;
        extraConfig = {
          GUNICORN_MEDIA = true;
          # Explicitly set insecure value (skips warning)
          MEDIA_ROOT = "/var/lib/tandoor-recipes";
        };
      };
    };

    specialisation.oldVersionOverrideMedia.configuration = {
      system.stateVersion = "25.11";
      services.tandoor-recipes = {
        enable = true;
        extraConfig = {
          GUNICORN_MEDIA = true;
          MEDIA_ROOT = "/var/lib/tandoor-recipes/media";
        };
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      specBase = "${nodes.machine.system.build.toplevel}/specialisation";
      oldVersion = "${specBase}/oldVersion";
      oldVersionOverrideMedia = "${specBase}/oldVersionOverrideMedia";
    in
    # python
    ''
      def wait_for_tandoor():
        machine.wait_for_unit("tandoor-recipes.service")
        machine.wait_for_open_port(8080)


      def stop_and_rm():
        machine.systemctl("stop tandoor-recipes")
        machine.succeed("rm -r /var/lib/tandoor-recipes")


      db_path = "http://localhost:8080/media/db.sqlite3"


      # The media folder shouldn't contain the database. Subsequently it
      # should **not** get served, resulting in a 404. Previously the
      # database was located in the media folder. Therefore serving the media
      # folder would expose the database. See #338339.
      wait_for_tandoor()
      machine.succeed(f"curl --head {db_path} | grep \"HTTP/1.1 404 Not Found\"")


      # Switch to NixOS 25.11 to check if the setup still functions the same
      # as before.
      stop_and_rm()
      machine.succeed("${oldVersion}/bin/switch-to-configuration test")

      # With the old setup the media folder should contain the database.
      # Subsequently it should get served, resulting in a 200.
      wait_for_tandoor()
      machine.succeed(f"curl --head {db_path} | grep \"HTTP/1.1 200 OK\"")


      # Switch to NixOS 25.11 with the MEDIA_ROOT already set to
      # /var/lib/tandoor-recipes/media.
      stop_and_rm()
      machine.succeed("${oldVersionOverrideMedia}/bin/switch-to-configuration test")

      # With MEDIA_ROOT being set to /var/lib/tandoor-recipes/media the media
      # folder shouldn't contain the database. Subsequently it should **not**
      # get served, resulting in a 404.
      wait_for_tandoor()
      machine.succeed(f"curl --head {db_path} | grep \"HTTP/1.1 404 Not Found\"")
    '';
}
