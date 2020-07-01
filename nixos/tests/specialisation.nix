import ./make-test-python.nix {
  name = "specialisation";
  nodes =  {
    inheritconf = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.cowsay ];
      specialisation.inheritconf.configuration = { pkgs, ... }: {
        environment.systemPackages = [ pkgs.hello ];
      };
    };
    noinheritconf = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.cowsay ];
      specialisation.noinheritconf = {
        inheritParentConfig = false;
        configuration = { pkgs, ... }: {
          environment.systemPackages = [ pkgs.hello ];
        };
      };
    };
  };
  testScript = ''
    inheritconf.wait_for_unit("default.target")
    inheritconf.succeed("cowsay hey")
    inheritconf.fail("hello")

    with subtest("Nested clones do inherit from parent"):
        inheritconf.succeed(
            "/run/current-system/specialisation/inheritconf/bin/switch-to-configuration test"
        )
        inheritconf.succeed("cowsay hey")
        inheritconf.succeed("hello")

        noinheritconf.wait_for_unit("default.target")
        noinheritconf.succeed("cowsay hey")
        noinheritconf.fail("hello")

    with subtest("Nested children do not inherit from parent"):
        noinheritconf.succeed(
            "/run/current-system/specialisation/noinheritconf/bin/switch-to-configuration test"
        )
        noinheritconf.fail("cowsay hey")
        noinheritconf.succeed("hello")
  '';
}
