import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    textInput = "This works.";
    inputBoxText = "Enter input";
    inputBox = pkgs.writeShellScript "zenity-input" ''
      ${lib.getExe pkgs.gnome.zenity} --entry --text '${inputBoxText}:' > /tmp/output &
    '';
  in
  {
    name = "ydotool";

    meta = {
      maintainers = with lib.maintainers; [
        OPNA2608
        quantenzitrone
      ];
    };

    nodes = {
      headless =
        { config, ... }:
        {
          imports = [ ./common/user-account.nix ];

          users.users.alice.extraGroups = [ "ydotool" ];

          programs.ydotool.enable = true;

          services.getty.autologinUser = "alice";
        };

      x11 =
        { config, ... }:
        {
          imports = [
            ./common/user-account.nix
            ./common/auto.nix
            ./common/x11.nix
          ];

          users.users.alice.extraGroups = [ "ydotool" ];

          programs.ydotool.enable = true;

          test-support.displayManager.auto = {
            enable = true;
            user = "alice";
          };

          services.xserver.windowManager.dwm.enable = true;
          services.displayManager.defaultSession = lib.mkForce "none+dwm";
        };

      wayland =
        { config, ... }:
        {
          imports = [ ./common/user-account.nix ];

          services.cage = {
            enable = true;
            user = "alice";
          };

          programs.ydotool.enable = true;

          services.cage.program = inputBox;
        };
    };

    enableOCR = true;

    testScript =
      { nodes, ... }:
      ''
        def as_user(cmd: str):
          """
          Return a shell command for running a shell command as a specific user.
          """
          return f"sudo -u alice -i {cmd}"

        start_all()

        # Headless
        headless.wait_for_unit("multi-user.target")
        headless.wait_for_text("alice")
        headless.succeed(as_user("ydotool type 'echo ${textInput} > /tmp/output'")) # text input
        headless.succeed(as_user("ydotool key 28:1 28:0")) # text input
        headless.screenshot("headless_input")
        headless.wait_for_file("/tmp/output")
        headless.wait_until_succeeds("grep '${textInput}' /tmp/output") # text input

        # X11
        x11.wait_for_x()
        x11.execute(as_user("${inputBox}"))
        x11.wait_for_text("${inputBoxText}")
        x11.succeed(as_user("ydotool type '${textInput}'")) # text input
        x11.screenshot("x11_input")
        x11.succeed(as_user("ydotool mousemove -a 400 110")) # mouse input
        x11.succeed(as_user("ydotool click 0xC0")) # mouse input
        x11.wait_for_file("/tmp/output")
        x11.wait_until_succeeds("grep '${textInput}' /tmp/output") # text input

        # Wayland
        wayland.wait_for_unit("graphical.target")
        wayland.wait_for_text("${inputBoxText}")
        wayland.succeed("ydotool type '${textInput}'") # text input
        wayland.screenshot("wayland_input")
        wayland.succeed("ydotool mousemove -a 100 100") # mouse input
        wayland.succeed("ydotool click 0xC0") # mouse input
        wayland.wait_for_file("/tmp/output")
        wayland.wait_until_succeeds("grep '${textInput}' /tmp/output") # text input
      '';
  }
)
