import ./make-test-python.nix ({ pkgs, ...} :

{
  name = "keepassxc";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ turion ];
    timeout = 1800;
  };

  nodes.machine = { ... }:

  {
    imports = [
      ./common/user-account.nix
      ./common/x11.nix
    ];

    services.xserver.enable = true;

    # Regression test for https://github.com/NixOS/nixpkgs/issues/163482
    qt = {
      enable = true;
      platformTheme = "gnome";
      style = "adwaita-dark";
    };

    test-support.displayManager.auto.user = "alice";
    environment.systemPackages = with pkgs; [
      keepassxc
      xdotool
    ];
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    aliceDo = cmd: ''machine.succeed("su - alice -c '${cmd}' >&2 &");'';
    in ''
    with subtest("Ensure X starts"):
        start_all()
        machine.wait_for_x()

    with subtest("Can create database and entry with CLI"):
        ${aliceDo "keepassxc-cli db-create -k foo.keyfile foo.kdbx"}
        ${aliceDo "keepassxc-cli add --no-password -k foo.keyfile foo.kdbx bar"}

    with subtest("Ensure KeePassXC starts"):
        # start KeePassXC window
        ${aliceDo "keepassxc >&2 &"}

        machine.wait_for_text("KeePassXC ${pkgs.keepassxc.version}")
        machine.screenshot("KeePassXC")

    with subtest("Can open existing database"):
        machine.send_key("ctrl-o")
        machine.sleep(5)
        # Regression #163482: keepassxc did not crash
        machine.succeed("ps -e | grep keepassxc")
        machine.wait_for_text("Open database")
        machine.send_key("ret")

        # Wait for the enter password screen to appear.
        machine.wait_for_text("/home/alice/foo.kdbx")

        # Click on "Browse" button to select keyfile
        machine.send_key("tab")
        machine.send_chars("/home/alice/foo.keyfile")
        machine.send_key("ret")
        # Database is unlocked (doesn't have "[Locked]" in the title anymore)
        machine.wait_for_text("foo.kdbx - KeePassXC")
  '';
})
