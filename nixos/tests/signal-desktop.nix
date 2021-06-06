import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "signal-desktop";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ flokli primeos ];
  };

  machine = { ... }:

  {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    test-support.displayManager.auto.user = "alice";
    environment.systemPackages = with pkgs; [ signal-desktop file ];
    virtualisation.memorySize = 1024;
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.users.alice;
  in ''
    start_all()
    machine.wait_for_x()

    # start signal desktop
    machine.execute("su - alice -c signal-desktop &")

    # Wait for the Signal window to appear. Since usually the tests
    # are run sandboxed and therfore with no internet, we can not wait
    # for the message "Link your phone ...". Nor should we wait for
    # the "Failed to connect to server" message, because when manually
    # running this test it will be not sandboxed.
    machine.wait_for_text("Signal")
    machine.wait_for_text("File Edit View Window Help")
    machine.screenshot("signal_desktop")

    # Test if the database is encrypted to prevent these issues:
    # - https://github.com/NixOS/nixpkgs/issues/108772
    # - https://github.com/NixOS/nixpkgs/pull/117555
    print(machine.succeed("su - alice -c 'file ~/.config/Signal/sql/db.sqlite'"))
    machine.fail(
        "su - alice -c 'file ~/.config/Signal/sql/db.sqlite' | grep -e SQLite -e database"
    )
  '';
})
