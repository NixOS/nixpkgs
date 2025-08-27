{ lib, ... }:
{
  name = "lomiri-weather-app-standalone";
  meta = {
    maintainers = lib.teams.lomiri.members;
    # This needs a Linux VM
    platforms = lib.platforms.linux;
  };

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ ./common/x11.nix ];

      services.xserver.enable = true;

      environment = {
        systemPackages =
          with pkgs;
          [
            xdotool # mouse movement
          ]
          ++ (with pkgs.lomiri; [
            suru-icon-theme
            lomiri-weather-app
          ]);
        variables = {
          UITK_ICON_THEME = "suru";
        };
      };

      # Weather app needs lomiri-indicator-network, which in turn needs NM
      networking.networkmanager.enable = true;
      services.ayatana-indicators = {
        enable = true;
        packages = with pkgs.lomiri; [
          lomiri-indicator-network
        ];
      };

      i18n.supportedLocales = [ "all" ];

      fonts = {
        packages = with pkgs; [
          # Intended font & helps with OCR
          ubuntu-classic
        ];
      };
    };

  enableOCR = true;

  testScript = ''
    def xterm_in_session():
        """
        Launch xterm in session
        """
        machine.succeed("xdotool mousemove 20 750 click 1") # open start menu
        machine.wait_for_text(r"(xterm|Other|System|Programs|Toolbar|Windows|Settings|Logout...)")
        machine.succeed("xdotool mousemove 20 570 click 1") # launch xterm in session
        machine.wait_for_window("root@machine: ~")

    machine.wait_for_x()

    # Weather app needs network indicator to be running
    machine.systemctl("start lomiri-indicators.target", user="root")
    machine.wait_for_unit("lomiri-indicator-network.service", user="root")

    # Because we need to launch the app from within the session, and we're using xterm to modify LANG for the localisation test,
    # we loose app output in log.
    # Create a file to redirect output into & keep reading it from throughout the test
    machine.succeed("touch /tmp/weather-output.log")
    machine.succeed("tail -f /tmp/weather-output.log >&2 &")

    with subtest("lomiri weather launches"):
        # For the app to properly talk with the network indicator, it needs to be launched from within the session
        xterm_in_session()
        machine.send_chars("lomiri-weather-app 2>&1 | tee -a /tmp/weather-output.log; exit\n")
        machine.sleep(2)
        machine.wait_for_text(r"(weather.ubports|location|Manually)")
        machine.screenshot("lomiri-weather_open")

    with subtest("lomiri weather works"):
        machine.succeed("xdotool mousemove 700 600 click 1") # Locations page
        machine.wait_for_text(r"(No locations|Tap|plus|search)")

        # would need proper network connections to geonames & open-meteo to check further functionality
        machine.screenshot("lomiri-weather_works")

    machine.succeed("pkill -f lomiri-weather-app")

    with subtest("lomiri weather localisation works"):
        # For the app to properly talk with the network indicator, it needs to be launched from within the session
        xterm_in_session()
        machine.send_chars("env LANG=de_DE.UTF-8 lomiri-weather-app 2>&1 | tee -a /tmp/weather-output.log; exit\n")
        machine.wait_for_text(r"(Standort|Wischen|manuell)")
        machine.screenshot("lomiri-weather_localised")
  '';
}
