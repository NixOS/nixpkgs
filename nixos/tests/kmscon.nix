{ ... }:
{
  name = "kmscon";

  nodes.machine =
    {
      pkgs,
      ...
    }:
    {
      imports = [
        ./common/user-account.nix
      ];

      services.getty.autologinUser = "alice";

      hardware.graphics.enable = true;

      fonts = {
        fontconfig.enable = true;
        packages = [ pkgs.nerd-fonts.jetbrains-mono ];
      };

      services.kmscon = {
        enable = true;
        package = pkgs.kmscon;
        config = {
          font-name = "JetBrainsMono Nerd Font";
          hwaccel = true;
          term = "kmscon";
        };
      };
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_unit("default.target")

    with subtest("ensure we can open a tty"):
      machine.wait_for_text("alice@machine")

      machine.send_chars("echo $TERM | tee /tmp/term.txt\n")
      machine.wait_until_succeeds("test -s /tmp/term.txt")
      term = machine.succeed("cat /tmp/term.txt").strip()
      assert term == "kmscon", f"Unexpected TERM value: {term!r}"

      machine.screenshot("tty.png")
  '';
}
