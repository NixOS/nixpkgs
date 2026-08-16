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
          ++ (with pkgs.lomiri-qt6; [
            suru-icon-theme
            lomiri-weather-app
          ]);
        variables = {
          UITK_ICON_THEME = "suru";
        };
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
    machine.wait_for_x()

    with subtest("lomiri weather launches"):
        machine.succeed("lomiri-weather-app >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text(r"(weather.ubports|location|Manually)")
        machine.screenshot("lomiri-weather_open")

    with subtest("lomiri weather works"):
        machine.succeed("xdotool mousemove 530 750 click 1") # Locations page
        machine.sleep(5)
        machine.wait_for_text(r"(No locations|Tap|plus|search)")

        # would need proper network connections to geonames & open-meteo to check further functionality
        machine.screenshot("lomiri-weather_works")

    machine.succeed("pgrep -afx lomiri-weather-app >&2")
    machine.succeed("pkill -efx lomiri-weather-app >&2")
    machine.wait_until_fails("pgrep -afx lomiri-weather-app >&2")

    with subtest("lomiri weather localisation works"):
        machine.succeed("env LANG=de_DE.UTF-8 lomiri-weather-app >&2 &")
        machine.sleep(10)
        machine.send_key("alt-f10")
        machine.sleep(5)
        machine.wait_for_text(r"(Standort|Wischen|manuell)")
        machine.screenshot("lomiri-weather_localised")
  '';
}
