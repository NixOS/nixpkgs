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

    # Create a file that we'll open
    machine.succeed("su - alice -c 'echo \"   Hello World\" > foo.txt'")

    # It's one line long
    assert "1 foo.txt" in machine.succeed(
        "su - alice -c 'wc foo.txt -l'"
    ), "File has wrong length"

    # Start VSCodium with that file
    machine.succeed("su - alice -c 'codium foo.txt' &")

    # Wait for the window to appear
    machine.wait_for_text("VSCodium")

    # Add a line
    machine.send_key("ret")

    # Save file
    machine.send_key("ctrl-s")

    # Wait until the file has been saved
    machine.sleep(1)

    # Now the file is 2 lines long
    assert "2 foo.txt" in machine.succeed(
        "su - alice -c 'wc foo.txt -l'"
    ), "File has wrong length"

    machine.screenshot("VSCodium")
  '';
})
