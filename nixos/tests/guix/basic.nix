# Take note the Guix store directory is empty. Also, we're trying to prevent
# Guix from trying to downloading substitutes because of the restricted
# access (assuming it's in a sandboxed environment).
#
# So this test is what it is: a basic test while trying to use Guix as much as
# we possibly can (including the API) without triggering its download alarm.

import ../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "guix-basic";
    meta.maintainers = with lib.maintainers; [ foo-dogsquared ];

    nodes.machine =
      { config, ... }:
      {
        environment.etc."guix/scripts".source = ./scripts;
        services.guix = {
          enable = true;
          gc.enable = true;
        };
      };

    testScript = ''
      import pathlib

      machine.wait_for_unit("multi-user.target")
      machine.wait_for_unit("guix-daemon.service")
      machine.succeed("systemctl start guix-gc.service")

      # Can't do much here since the environment has restricted network access.
      with subtest("Guix basic package management"):
        machine.succeed("guix build --dry-run --verbosity=0 hello")
        machine.succeed("guix show hello")

      # This is to see if the Guix API is usable and mostly working.
      with subtest("Guix API scripting"):
        scripts_dir = pathlib.Path("/etc/guix/scripts")

        text_msg = "Hello there, NixOS!"
        text_store_file = machine.succeed(f"guix repl -- {scripts_dir}/create-file-to-store.scm '{text_msg}'")
        assert machine.succeed(f"cat {text_store_file}") == text_msg

        machine.succeed(f"guix repl -- {scripts_dir}/add-existing-files-to-store.scm {scripts_dir}")
    '';
  }
)
