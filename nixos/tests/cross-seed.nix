{ lib, ... }:
let
  apiKey = "twentyfourcharacterskey!";
in
{
  name = "cross-seed";
  meta.maintainers = with lib.maintainers; [ pta2002 ];

  nodes.machine =
    { pkgs, config, ... }:
    let
      cfg = config.services.cross-seed;
    in
    {
      systemd.tmpfiles.settings."0-cross-seed-test"."${cfg.settings.torrentDir}".d = {
        inherit (cfg) user group;
        mode = "700";
      };

      services.cross-seed = {
        enable = true;
        settings = {
          torrentDir = "/var/lib/torrents";
          torznab = [ ];
          useClientTorrents = false;
        };
        # # We create this secret in the Nix store (making it readable by everyone).
        # # DO NOT DO THIS OUTSIDE OF TESTS!!
        settingsFile = (pkgs.formats.json { }).generate "secrets.json" {
          inherit apiKey;
        };
      };
    };

  testScript = # python
    ''
      start_all()
      machine.wait_for_unit("cross-seed.service")
      machine.wait_for_open_port(2468)
      # Check that the API is running
      machine.succeed("curl --fail http://localhost:2468/api/ping?apiKey=${apiKey}")
    '';
}
