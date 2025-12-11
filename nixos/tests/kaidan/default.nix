{
  lib,
  ...
}:
{
  name = "Kaidan XMPP Chat App";

  nodes = {
    machine =
      {
        pkgs,
        ...
      }:
      {
        imports = [
          # enable graphical session + users (alice, bob)
          ../common/x11.nix
          ../common/user-account.nix

          # XMPP server for Kaidan
          ./prosody.nix
        ];

        test-support.displayManager.auto.user = "alice";

        environment.systemPackages = with pkgs; [
          kaidan
          xdotool # automated mouse clicks
        ];

        # Kaidan requires a keyring for storing user passwords
        services.gnome.gnome-keyring.enable = true;
      };
  };

  enableOCR = true;
  interactive.sshBackdoor.enable = true; # ssh -o User=root vsock/3

  testScript =
    { nodes, ... }:
    let
      users.john = {
        email = "john@example.com";
        password = "foobar";
        message = "Hello, I'm John!";
      };

      users.alice = {
        email = "alice@example.com";
        password = "foobar";
        message = "Hello, I'm Alice!";
      };
    in
    # py
    ''
      import json

      users = json.loads("""${lib.strings.toJSON users}""")

      def wait_main_screen():
        machine.wait_for_text(r"(Kaidan|free|communication|every|device)")

      def click_position(x: int, y: int):
        machine.succeed(f"su - alice -c 'DISPLAY=:0 xdotool mousemove --sync {x} {y} click 1'")
        machine.sleep(1)

      def login_user(user: str):
        machine.send_chars(f"{users[user]["email"]}\n", 0.1)
        machine.sleep(1)
        machine.send_chars(f"{users[user]["password"]}\n", 0.1)

      # add user account
      def add_user_account(user: str):
        click_position(26, 48) # burger menu
        click_position(179, 144) # add account

        wait_main_screen()
        click_position(366, 598) # chat address
        login_user(user)
        machine.sleep(1)

      # add user to the contact list
      # NOTE: currently, we're hardcoding this to add to john's contact list,
      # since it's simpler than somehow reading the screen, determining where
      # each user is positioned and choosing them.
      def add_contact(user, message=""):
        click_position(26, 48) # burger menu
        machine.wait_for_text(r"(Add|contact|chat|QR|code|address)")
        click_position(225, 344) # Add contact by chat address
        click_position(404, 359) # Add contact to john

        machine.send_chars(f"{users[user]["email"]}\n",0.1);
        machine.sleep(1)
        machine.send_key("tab")
        machine.send_key("tab")
        machine.sleep(1)
        machine.send_chars(f"{message if message != "" else users[user]["message"]}\n",0.1);
        machine.sleep(1)

        click_position(511, 524) # Add

      # send a message
      def send_message(message):
        click_position(602, 742) # message box
        machine.send_chars(f"{message}\n", 0.2)
        machine.sleep(1)

      ## START ##
      start_all()
      machine.wait_for_x()

      # Setup prosody so we can connect
      machine.wait_for_unit("prosody.service")
      machine.succeed("create-prosody-users")
      machine.systemctl("start network-online.target")
      machine.wait_for_unit("network-online.target")

      # Start Kaidan and scale it to full screen
      machine.execute("env DISPLAY=:0 sudo -u alice kaidan >&2 &")
      wait_main_screen()
      machine.send_key("alt-f10")
      machine.sleep(1)

      with subtest("Set up users"):
        login_user("john")

        # set up keyring for storing user passwords
        machine.wait_for_text(r"(Choose|keyring|Default|Confirm|Continue)")
        machine.send_chars("foobar", 0.1)
        machine.send_key("tab")
        machine.send_chars("foobar\n", 0.1)
        machine.wait_for_text(r"(Search|Select|chat|start)")

        # we add a second account, which will be communicating with the first one
        add_user_account("alice")
        machine.wait_for_text(r"(Search|Select|chat|start)")

      # NOTE: OCR doesn't work well here. We assume both messages are received
      # and just take a screenshot.
      # TODO: verify messages exist in the screenshot.
      with subtest("Chat between 2 users"):
        # add alice to john's contacts with an initial message
        add_contact("alice", users["john"]["message"])
        machine.sleep(5)

        # john sends alice a message
        click_position(151, 110) # alice in john's contacts
        send_message(users["john"]["message"])

        # alice receives john's message and replies
        click_position(151, 183) # john in alice's contacts
        send_message(users["alice"]["message"])

        # john receives alice's message
        click_position(151, 110) # alice in john's contacts
        machine.screenshot("kaidan_chat_log") # both messages should be here
    '';
}
