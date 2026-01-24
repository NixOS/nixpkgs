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
    machine.succeed(":")
    # ^ this create a screen

    with subtest("ensure we can open a tty"):
      machine.wait_for_text("machine login:")
      machine.send_chars("alice\n")
      machine.wait_for_text("Password:")
      machine.send_chars("foobar\n")
      machine.wait_for_text("alice@machine")
      machine.screenshot("tty.png")
  '';
}
