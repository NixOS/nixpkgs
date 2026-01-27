{ pkgs, ... }:
{
  name = "deemix";
  meta.maintainers = with pkgs.lib.maintainers; [ JalilArfaoui ];

  nodes.machine =
    { ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      services.xserver.enable = true;
      test-support.displayManager.auto.user = "alice";
      environment.systemPackages = [ pkgs.deemix ];
    };

  enableOCR = true;

  testScript = ''
    start_all()
    machine.wait_for_x()

    # Start deemix
    machine.execute("su - alice -c deemix >&2 &")

    # Wait for the Deemix window to appear
    # The app shows "deemix" in the title bar
    machine.wait_for_text("deemix")
    machine.screenshot("deemix")
  '';
}
