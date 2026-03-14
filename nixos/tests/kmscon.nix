{ ... }:
{
  name = "kmscon";

  nodes.machine =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        ./common/user-account.nix
      ];

      services.kmscon = {
        enable = true;
        hwRender = true;
        fonts = [
          {
            name = "JetBrainsMono Nerd Font";
            package = pkgs.nerd-fonts.jetbrains-mono;
          }
        ];
        package = pkgs.kmscon;
      };
    };

  enableOCR = true;

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("ensure we can open a tty"):
      machine.wait_for_text("machine login:")

      machine.send_chars("alice\n")
      machine.wait_for_text("Password:")

      machine.send_chars("foobar\n")
      machine.wait_for_text("alice@machine")

      machine.send_chars("echo $TERM | tee /tmp/term.txt\n")
      machine.wait_until_succeeds("test -s /tmp/term.txt")
      term = machine.succeed("cat /tmp/term.txt").strip()
      assert term == "xterm-256color", f"Unexpected TERM value: {term!r}"

      machine.screenshot("tty.png")
  '';
}
