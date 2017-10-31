import ./make-test.nix ({ pkgs, ...} : {
  name = "slim";

  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  machine = { pkgs, lib, ... }: {
    imports = [ ./common/user-account.nix ];
    services.xserver.enable = true;
    services.xserver.windowManager.default = "icewm";
    services.xserver.windowManager.icewm.enable = true;
    services.xserver.desktopManager.default = "none";
    services.xserver.displayManager.slim = {
      enable = true;

      # Use a custom theme in order to get best OCR results
      theme = pkgs.runCommand "slim-theme-ocr" {
        nativeBuildInputs = [ pkgs.imagemagick ];
      } ''
        mkdir "$out"
        convert -size 1x1 xc:white "$out/background.jpg"
        convert -size 200x100 xc:white "$out/panel.jpg"
        cat > "$out/slim.theme" <<EOF
        background_color #ffffff
        background_style tile

        input_fgcolor #000000
        msg_color #000000

        session_color #000000
        session_font Verdana:size=16:bold

        username_msg Username:
        username_font Verdana:size=16:bold
        username_color #000000
        username_x 50%
        username_y 40%

        password_msg Password:
        password_x 50%
        password_y 40%
        EOF
      '';
    };
  };

  enableOCR = true;

  testScript = { nodes, ... }: let
    user = nodes.machine.config.users.extraUsers.alice;
  in ''
    startAll;
    $machine->waitForText(qr/Username:/);
    $machine->sendChars("${user.name}\n");
    $machine->waitForText(qr/Password:/);
    $machine->sendChars("${user.password}\n");

    $machine->waitForFile('${user.home}/.Xauthority');
    $machine->succeed('xauth merge ${user.home}/.Xauthority');
    $machine->waitForWindow('^IceWM ');

    # Make sure SLiM doesn't create a log file
    $machine->fail('test -e /var/log/slim.log');
  '';
})
