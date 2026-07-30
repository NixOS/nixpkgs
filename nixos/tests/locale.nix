{ ... }:
{
  name = "imperative-locale";
  meta.maintainers = [ ];

  nodes = {
    node_static =
      { ... }:
      {
        i18n = {
          defaultLocale = "lt_LT.UTF-8";
          extraLocales = [ "en_US.UTF-8/UTF-8" ];
        };
      };

    node_imperative =
      { ... }:
      {
        i18n = {
          defaultLocale = "lt_LT.UTF-8";
          imperativeLocale = true;
          extraLocales = [ "en_US.UTF-8/UTF-8" ];
        };
      };
  };

  testScript =
    { ... }:
    ''
      node_static.wait_for_unit("dbus.socket")

      with subtest("static - declared locale is reported by localectl"):
          node_static.succeed("localectl status | grep -q 'System Locale: LANG=lt_LT.UTF-8'")

      with subtest("static - localectl set-locale is blocked"):
          node_static.fail("localectl set-locale LANG=en_US.UTF-8")
          node_static.succeed("localectl status | grep -q 'System Locale: LANG=lt_LT.UTF-8'")

      node_imperative.wait_for_unit("dbus.socket")

      with subtest("imperative - declared locale is reported by localectl on first boot"):
          node_imperative.succeed("localectl status | grep -q 'System Locale: LANG=lt_LT.UTF-8'")

      with subtest("imperative - localectl set-locale changes the locale"):
          node_imperative.succeed("localectl set-locale LANG=en_US.UTF-8")
          node_imperative.succeed("localectl status | grep -q 'System Locale: LANG=en_US.UTF-8'")

      with subtest("imperative - locale change persists across reboot"):
          node_imperative.shutdown()
          node_imperative.wait_for_unit("dbus.socket")
          node_imperative.succeed("localectl status | grep -q 'System Locale: LANG=en_US.UTF-8'")
    '';
}
