import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "keepassxc";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ turion ];
  };

  machine = { ... }:

  {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    services.xserver.enable = true;
    test-support.displayManager.auto.user = "alice";
    environment.systemPackages = [ pkgs.keepassxc ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: ''
    start_all()
    machine.wait_for_x()

    # start KeePassXC window
    machine.execute("su - alice -c keepassxc >&2 &")

    machine.wait_for_text("KeePassXC ${pkgs.keepassxc.version}")
    machine.screenshot("KeePassXC")
  '';
})
