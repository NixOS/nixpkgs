import ./make-test-python.nix ({ pkgs, ... }: {
  name = "starship";
  meta.maintainers = pkgs.starship.meta.maintainers;

  machine = {
    programs = {
      fish.enable = true;
      zsh.enable = true;

      starship = {
        enable = true;
        settings.format = "<starship>";
      };
    };

    services.getty.autologinUser = "root";
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    for shell in ["bash", "fish", "zsh"]:
      machine.send_chars(f"script -c {shell} /tmp/{shell}.txt\n")
      machine.wait_until_tty_matches(1, f"Script started.*{shell}.txt")
      machine.send_chars("exit\n")
      machine.wait_until_tty_matches(1, "Script done")
      machine.sleep(1)
      machine.succeed(f"grep -q '<starship>' /tmp/{shell}.txt")
  '';
})
