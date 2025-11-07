{ lib, pkgs, ... }:

{
  name = "qownnotes";
  meta.maintainers = [ lib.maintainers.pbek ];

  nodes.machine =
    { ... }:

    {
      imports = [
        ./common/user-account.nix
        ./common/x11.nix
      ];

      test-support.displayManager.auto.user = "alice";
      environment.systemPackages = [
        pkgs.qownnotes
        pkgs.xdotool
      ];
    };

  enableOCR = true;

  # https://nixos.org/manual/nixos/stable/#ssec-machine-objects
  testScript =
    { nodes, ... }:
    let
      aliceDo = cmd: ''machine.succeed("su - alice -c '${cmd}' >&2 &");'';
    in
    ''
      with subtest("Ensure X starts"):
          start_all()
          machine.wait_for_x()

      with subtest("Check QOwnNotes version on CLI"):
          ${aliceDo "qownnotes --version"}

          machine.wait_for_console_text("QOwnNotes ${pkgs.qownnotes.version}")

      with subtest("Ensure QOwnNotes starts"):
          # start QOwnNotes window
          ${aliceDo "qownnotes"}

          machine.wait_for_text("Welcome to QOwnNotes")
          machine.screenshot("QOwnNotes-Welcome")

      with subtest("Finish first-run wizard"):
          # The wizard should show up now
          machine.wait_for_text("Note folder")
          machine.send_key("ret")
          machine.wait_for_console_text("Note path '/home/alice/Notes' was now created.")
          machine.wait_for_text("Panel layout")
          machine.send_key("ret")
          machine.wait_for_text("Nextcloud")
          machine.send_key("ret")

          # OCR can't detect "App metric" anymore, so we will wait for another text
          machine.wait_for_text("Open network settings")
          machine.send_key("ret")

          # Doesn't work for non-root
          #machine.wait_for_window("QOwnNotes - ${pkgs.qownnotes.version}")

          # OCR doesn't seem to be able any more to handle the main window
          #machine.wait_for_text("QOwnNotes - ${pkgs.qownnotes.version}")

          # The main window should now show up
          machine.wait_for_open_port(22222)
          machine.wait_for_console_text("QOwnNotes server listening on port 22222")

          machine.screenshot("QOwnNotes-DemoNote")

      with subtest("Create a new note"):
          machine.send_key("ctrl-n")
          machine.sleep(1)
          machine.send_chars("This is a NixOS test!\n")
          machine.wait_until_succeeds("find /home/alice/Notes -type f | grep -qi 'Note 2'")

          # OCR doesn't seem to be able any more to handle the main window
          #machine.wait_for_text("This is a NixOS test!")

          # Doesn't work for non-root
          #machine.wait_for_window("- QOwnNotes - ${pkgs.qownnotes.version}")

          machine.screenshot("QOwnNotes-NewNote")
    '';
}
