import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "vscodium";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ turion ];
  };

  machine = { ... }:

  {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    virtualisation.memorySize = 2047;
    services.xserver.enable = true;
    test-support.displayManager.auto.user = "alice";
    environment.systemPackages = with pkgs; [
      vscodium
    ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: ''
    # Start up X
    start_all()
    machine.wait_for_x()

    # Start VSCodium with a file that doesn't exist yet
    machine.fail("ls /home/alice/foo.txt")
    machine.succeed("su - alice -c 'codium foo.txt' >&2 &")

    # Wait for the window to appear
    machine.wait_for_text("VSCodium")

    # Save file
    machine.send_key("ctrl-s")

    # Wait until the file has been saved
    machine.wait_for_file("/home/alice/foo.txt")

    machine.screenshot("VSCodium")
  '';
})
