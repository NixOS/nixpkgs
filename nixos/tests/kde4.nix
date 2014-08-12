import ./make-test.nix ({ pkgs, ... }: {
  name = "kde4";

  machine =
    { config, pkgs, ... }:

    { imports = [ ./common/user-account.nix ];

      virtualisation.memorySize = 1024;

      services.xserver.enable = true;

      services.httpd.enable = true;
      services.httpd.adminAddr = "foo@example.org";
      services.httpd.documentRoot = "${pkgs.valgrind}/share/doc/valgrind/html";

      services.xserver.displayManager.kdm.enable = true;
      services.xserver.displayManager.kdm.extraConfig =
        ''
          [X-:0-Core]
          AutoLoginEnable=true
          AutoLoginUser=alice
          AutoLoginPass=foobar
        '';

      services.xserver.desktopManager.kde4.enable = true;

      # Include most of KDE. We don't really test these here, but at
      # least they should build.
      environment.systemPackages =
        [ pkgs.kde4.kdemultimedia
          pkgs.kde4.kdegraphics
          pkgs.kde4.kdeutils
          pkgs.kde4.kdegames
          pkgs.kde4.kdeedu
          pkgs.kde4.kdeaccessibility
          pkgs.kde4.kdeadmin
          pkgs.kde4.kdenetwork
          pkgs.kde4.kdetoys
          pkgs.kde4.kdewebdev
        ];
    };

  testScript =
    ''
      $machine->waitUntilSucceeds("pgrep plasma-desktop");
      $machine->waitForWindow(qr/plasma-desktop/);

      # Check that logging in has given the user ownership of devices.
      $machine->succeed("getfacl /dev/snd/timer | grep -q alice");

      $machine->execute("su - alice -c 'DISPLAY=:0.0 kwrite /var/log/messages &'");
      $machine->waitForWindow(qr/messages.*KWrite/);

      $machine->execute("su - alice -c 'DISPLAY=:0.0 konqueror http://localhost/ &'");
      $machine->waitForWindow(qr/Valgrind.*Konqueror/);

      $machine->execute("su - alice -c 'DISPLAY=:0.0 gwenview ${pkgs.kde4.kde_wallpapers}/share/wallpapers/Hanami/contents/images/1280x1024.jpg &'");
      $machine->waitForWindow(qr/Gwenview/);

      $machine->sleep(10);

      $machine->screenshot("screen");
    '';

})
