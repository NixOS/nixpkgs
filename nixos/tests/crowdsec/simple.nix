{ lib, ... }:
{
  name = "crowdsec-simple";
  meta.maintainers = with lib.maintainers; [ tornax ];

  nodes =
    let
      hub-addr = "127.0.0.1:49200";
    in
    {
      crowdsec-simple =
        { ... }:
        {
          services = {
            caddy = {
              enable = true;

              # serve local hub
              virtualHosts = {
                "http://${hub-addr}".extraConfig = ''
                  handle_path /master/* {
                    root ${./data/hub}
                    file_server
                  }
                '';
              };
            };

            crowdsec = {
              enable = true;
              settings.config.cscli = {
                hub_branch = "master";
                __hub_url_template__ = "http://${hub-addr}/%s/%s";
              };
            };
          };
        };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    # crowdsec should simply work...
    machine.succeed("pgrep --exact crowdsec")
  '';

  interactive.sshBackdoor.enable = true;
}
