{ pkgs, ... }: {
  name = "nushell";
  meta.maintainers = pkgs.nushell.meta.maintainers;

  # Tests the case of plugins being specified.
  nodes.machine = { ... }: {
    programs.nushell = {
      enable = true;
      plugins = with pkgs.nushellPlugins; [
        formats
        query
      ];
    };

    users.users.test = {
      isNormalUser = true;
      password = "test";
      shell = pkgs.nushell;
    };
    services.getty.autologinUser = "test";
  };

  # Tests the case where no plugins are specified (the default).
  nodes.noPlugins = { ... }: {
    programs.nushell = {
      enable = true;
      plugins = [ ];
    };
    users.users.test = {
      isNormalUser = true;
      password = "test";
      shell = pkgs.nushell;
    };
    services.getty.autologinUser = "test";
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    with subtest("interactive shell loads plugins via vendor autoload"):
        machine.wait_until_tty_matches("1", "Welcome to Nushell")
        machine.sleep(2)

        machine.send_chars("plugin list | to json | save -f /tmp/plugins.json\n")
        machine.sleep(2)

        output = machine.succeed("cat /tmp/plugins.json")
        assert "formats" in output, f"formats plugin not loaded in interactive session:\n{output}"
        assert "query" in output, f"query plugin not loaded in interactive session:\n{output}"

    with subtest("non-interactive invocation finds plugins via the registry"):
        # The first interactive launch should have registered the plugins via
        # `plugin add`, making them available for non-interactive shells.
        machine.succeed(
          "su - test -c 'nu -c \"plugin list | where name == formats | length\"' | grep 1"
        )
        machine.succeed(
          "su - test -c 'nu -c \"plugin list | where name == query | length\"' | grep 1"
        )

    with subtest("empty plugins list does not produce vendor autoload file"):
        noPlugins.wait_for_unit("default.target")
        noPlugins.succeed(
          "test ! -f /run/current-system/sw/share/nushell/vendor/autoload/50-nixos-plugins.nu"
        )
        noPlugins.succeed(
          "su - test -c 'nu -c \"plugin list | length\"' | grep 0"
        )
  '';
}
