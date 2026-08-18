{ pkgs, ... }:

{
  name = "devolo-cockpit";
  meta.maintainers = with pkgs.lib.maintainers; [ malix ];

  nodes.machine =
    { ... }:
    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      services.xserver.enable = true;
      test-support.displayManager.auto.user = "alice";

      environment.systemPackages = [
        pkgs.devolo-cockpit
      ];
    };

  testScript = ''
    start_all()
    machine.wait_for_x()

    # Test that devolo-cockpit starts in the user desktop session
    machine.succeed("su - alice -c 'devolo-cockpit' >&2 &")
    machine.wait_until_succeeds("pgrep dlancockpit")
  '';
}
