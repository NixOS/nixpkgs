{ lib, ... }:
{
  name = "crowdsec-simple";
  meta.maintainers = with lib.maintainers; [ tornax ];

  nodes =
    let
      hub-addr = "127.0.0.1:49200";
      branch = "nixos-test";
    in
    {
      crowdsec =
        { ... }:
        {
          services = {
            caddy = {
              enable = true;

              # serve local hub
              virtualHosts = {
                "http://${hub-addr}".extraConfig = ''
                  handle_path /${branch}/* {
                    root ${./data/hub}
                    file_server
                  }
                '';
              };
            };

            crowdsec = {
              enable = true;
              settings.config.cscli = {
                hub_branch = branch;
                __hub_url_template__ = "http://${hub-addr}/%s/%s";
              };
            };
          };
        };
    };

  testScript = ''
    crowdsec.start()
    crowdsec.wait_for_unit("multi-user.target")

    # crowdsec should simply work...
    crowdsec.succeed("pgrep --exact crowdsec")
  '';

  interactive.sshBackdoor.enable = true;
}
