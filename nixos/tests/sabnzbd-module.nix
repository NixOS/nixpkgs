{ lib, ... }:
{
  name = "sabnzbd";
  meta.maintainers = with lib.maintainers; [ jojosch ];

  node.pkgsReadOnly = false;

  nodes.machine =
    { pkgs, lib, ... }:
    {
      services.sabnzbd = {
        enable = true;
        secretFiles = [
          (pkgs.writeText "secret-a.toml" ''
            [servers]
            [[example.com]]
            required=1
            priority=2
          '')
          (pkgs.writeText "secret-b.toml" ''
            [servers]
            [[example.com]]
            enable=1
            priority=5
          '')
        ];
        settings = {
          misc = {
            html_login = false;
            inet_exposure = "api (full)";
            api_key = "123456";
          };
          servers."example.com" = {
            enable = false;
            required = false;
            optional = true;
            displayname = "example.com";
            host = "example.com";
            name = "example.com";
          };
        };
      };

      environment.systemPackages = [
        pkgs.jq
        (pkgs.writeScriptBin "do_test" ''
          set -euxo pipefail

          misc_url="http://127.0.0.1:8080/api?mode=get_config&section=misc&output=json&apikey=123456"
          servers_url="http://127.0.0.1:8080/api?mode=get_config&section=servers&output=json&apikey=123456"

          [[ $(curl $misc_url | jq .config.misc.inet_exposure) == 3 ]]
          [[ $(curl $misc_url | jq .config.misc.html_login) == "false" ]]

          [[ $(curl $servers_url | jq .config.servers[0].enable) == 1 ]]
          [[ $(curl $servers_url | jq .config.servers[0].required) == 1 ]]
          [[ $(curl $servers_url | jq .config.servers[0].optional) == 1 ]]
          [[ $(curl $servers_url | jq .config.servers[0].priority) == 5 ]]
        '')
      ];

      # unrar is unfree
      nixpkgs.config.allowUnfreePackages = [ "unrar" ];
    };

  testScript = ''

    machine.wait_for_unit("sabnzbd.service")
    machine.wait_until_succeeds(
        "curl --fail -L http://localhost:8080/"
    )

    machine.succeed("do_test")
  '';
}
