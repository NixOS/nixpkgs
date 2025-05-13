{
  config,
  pkgs,
  ...
}:

{
  users.users.alice = {
    isNormalUser = true;
    description = "Alice Foobar";
    password = "foobar";
    uid = 1000;
  };

  users.users.bob = {
    isNormalUser = true;
    description = "Bob Foobar";
    password = "foobar";
  };

  # Help with OCR
  systemd.tmpfiles.settings =
    let
      icewm-testing-theme-file = pkgs.writeText "icewm-testing-theme" ''
        Theme="gtk2/default.theme"
      '';
      fixIcewmThemeForUser =
        user:
        let
          icewmSettingsDir = "${config.users.users."${user}".home}/.icewm";
        in
        {
          "${icewmSettingsDir}".d = {
            mode = "0700";
            inherit user;
            group = "users";
          };
          "${icewmSettingsDir}/theme".L.argument = builtins.toString icewm-testing-theme-file;
        };
    in
    {
      "11-icewm-alice-test-setup" = fixIcewmThemeForUser "alice";
      "11-icewm-bob-test-setup" = fixIcewmThemeForUser "bob";
    };
}
