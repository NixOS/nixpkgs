import ./make-test-python.nix (
  { pkgs, ... }:
  {
    name = "emacs-daemon";
    meta = with pkgs.lib.maintainers; {
      maintainers = [ ];
    };

    enableOCR = true;

    nodes.machine =
      { ... }:

      {
        imports = [ ./common/x11.nix ];
        services.emacs = {
          enable = true;
          defaultEditor = true;
        };

        # Important to get the systemd service running for root
        environment.variables.XDG_RUNTIME_DIR = "/run/user/0";

        environment.variables.TEST_SYSTEM_VARIABLE = "system variable";
      };

    testScript = ''
      machine.wait_for_unit("multi-user.target")

      # checks that the EDITOR environment variable is set
      machine.succeed('test $(basename "$EDITOR") = emacseditor')

      # waits for the emacs service to be ready
      machine.wait_until_succeeds(
          "systemctl --user status emacs.service | grep 'Active: active'"
      )

      # connects to the daemon
      machine.succeed("emacsclient --no-wait --frame-parameters='((display . \"'\"$DISPLAY\"'\"))' --create-frame $EDITOR >&2")

      # checks that Emacs shows the edited filename
      machine.wait_for_text("emacseditor")

      # makes sure environment variables are accessible from Emacs
      machine.succeed(
          "emacsclient --eval '(getenv \"TEST_SYSTEM_VARIABLE\")' | grep -q 'system variable'"
      )

      machine.screenshot("emacsclient")
    '';
  }
)
