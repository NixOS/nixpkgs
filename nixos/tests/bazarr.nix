{ lib, ... }:

let
  apikey = "0123456789abcdef0123456789abcdef";
  radarrApikey = "fedcba9876543210fedcba9876543210";
  port = 12345;

  expected = {
    analytics.enabled = false;
    auth = {
      inherit apikey;
      type = null;
    };
    general = {
      inherit port;
      instance_name = "from-settings";
    };
    plex.migration_timestamp = 1700000000.5;
    radarr.apikey = radarrApikey;
    subsync.checker.blacklisted_providers = [
      "fake-provider-a"
      "fake-provider-b"
    ];
  };
in
{
  name = "bazarr";

  meta.maintainers = with lib.maintainers; [
    connor-grady
    diogotcorreia
  ];

  nodes = {
    configured = {
      environment.etc = {
        "bazarr-apikey".text = apikey;
        "bazarr-radarr-apikey".text = radarrApikey;
      };
      services.bazarr = {
        enable = true;
        settings = lib.recursiveUpdate expected {
          auth.apikey._secret = "/etc/bazarr-apikey";
          radarr.apikey._secret = "/etc/bazarr-radarr-apikey";
        };
      };
    };

    defaults.services.bazarr.enable = true;
  };

  testScript = ''
    import json

    expected = json.loads('${builtins.toJSON expected}')

    def assert_subset(expected, actual, path=()):
      assert (expected_is_dict := isinstance(expected, dict)) == isinstance(actual, dict), (
        f"{path}: type mismatch (expected {type(expected).__name__}, got {type(actual).__name__})"
      )
      if expected_is_dict:
        for k, v in expected.items():
          assert_subset(v, actual[k], path + (k,))
      else:
        assert expected == actual, f"{path}: expected {expected!r}, got {actual!r}"

    def assert_declared():
      response = configured.succeed(
        "curl --fail -H 'X-API-KEY: ${apikey}' http://localhost:${toString port}/api/system/settings"
      )
      actual = json.loads(response)
      assert_subset(expected, actual)

    start_all()

    with subtest("declarative settings reach bazarr at correct paths"):
      configured.wait_for_unit("bazarr.service")
      configured.wait_for_open_port(${toString port})
      configured.wait_until_succeeds("curl --fail http://localhost:${toString port}/api/system/ping")
      assert_declared()

    with subtest("declarative settings override conflicting values in on-disk config.yaml"):
      configured.succeed("systemctl stop bazarr.service")
      configured.succeed(
        "sed -i -E 's|^( *instance_name: *)from-settings$|\\1from-disk|' /var/lib/bazarr/config/config.yaml"
      )
      configured.succeed("grep -qE '^ *instance_name: *from-disk$' /var/lib/bazarr/config/config.yaml")
      configured.succeed("systemctl start bazarr.service")
      configured.wait_for_open_port(${toString port})
      configured.wait_until_succeeds("curl --fail http://localhost:${toString port}/api/system/ping")
      assert_declared()

    with subtest("bazarr starts cleanly with no user-set settings"):
      defaults.wait_for_unit("bazarr.service")
      defaults.wait_for_open_port(6767)
      defaults.wait_until_succeeds("curl --fail http://localhost:6767/api/system/ping")
  '';
}
