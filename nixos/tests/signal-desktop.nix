import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "signal-desktop";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli ];
  };

  machine = { ... }:

  {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    test-support.displayManager.auto.user = "alice";
    environment.systemPackages = [ pkgs.signal-desktop ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    start_all()
    machine.wait_for_x()

    # start signal desktop
    machine.execute("su - alice -c signal-desktop &")

    # wait for the "Link your phone to Signal Desktop" message
    machine.wait_for_text("Link your phone to Signal Desktop")
    machine.screenshot("signal_desktop")
  '';
})
