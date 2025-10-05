{ config, lib, ... }:
{
  name = "geoclue2";
  meta = {
    maintainers = with lib.maintainers; [ rhendric ];
  };

  nodes.machine = {
    imports = [ common/user-account.nix ];

    location = {
      latitude = 12.345;
      longitude = -67.890;
    };

    services.geoclue2 = {
      enable = true;
      enableDemoAgent = true;
      enableStatic = true;
      staticAltitude = 123.45;
      staticAccuracy = 1000;
    };
  };

  testScript =
    let
      inherit (config.node) pkgs;
    in
    ''
      whereAmI = machine.succeed('machinectl shell alice@.host ${pkgs.geoclue2}/libexec/geoclue-2.0/demos/where-am-i -t 5')
      assert ("Latitude:    12.345000°" in whereAmI), f"Incorrect latitude in:\n{whereAmI}"
      assert ("Longitude:   -67.890000°" in whereAmI), f"Incorrect longitude in:\n{whereAmI}"
      assert ("Altitude:    123.450000 meters" in whereAmI), f"Incorrect altitude in:\n{whereAmI}"
      assert ("Accuracy:    1000.000000 meters" in whereAmI), f"Incorrect accuracy in:\n{whereAmI}"
    '';
}
