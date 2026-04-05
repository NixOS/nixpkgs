{ ... }:
{
  name = "tt-rss-nixos";

  nodes.machine =
    { pkgs, ... }:
    {
      services.tt-rss = {
        enable = true;
        virtualHost = "localhost";
        selfUrlPath = "http://localhost/";
        pluginPackages = with pkgs; [
          tt-rss-plugin-auth-ldap
          tt-rss-plugin-feediron
        ];
        plugins = [
          "auth_internal"
          "feediron"
          "note"
        ];
        singleUserMode = true;
        themePackages = with pkgs; [ tt-rss-theme-feedly ];
      };
    };

  testScript = ''
    import json
    import re
    machine.wait_for_unit("tt-rss.service")

    matches = re.search('__csrf_token = "([^"]*)"', machine.succeed("curl -sSfL --cookie cjar --cookie-jar cjar -sSfL http://localhost/"))
    if matches is None:
      assert False, "CSRF token not found"
    csrf_token = matches.group(1)

    # Ensure themes are loaded. No API found for these, so it's a crude check.
    preference_page = machine.succeed("curl -sSfL --cookie cjar --cookie-jar cjar http://localhost/backend.php?op=Pref_Prefs")
    assert "feedly" in preference_page

    plugins = json.loads(machine.succeed(f"curl -sSfL --cookie cjar --cookie-jar cjar 'http://localhost/backend.php' -X POST --data-raw 'op=Pref_Prefs&method=getPluginsList&csrf_token={csrf_token}'"))["plugins"]
    expected_plugins = ["auth_internal", "auth_ldap", "feediron", "note"];
    found_plugins = [p["name"] for p in plugins if p["name"] in expected_plugins]
    assert len(found_plugins) == len(expected_plugins), f"Expected plugins {expected_plugins}, found {found_plugins}"
  '';
}
