import ../make-test-python.nix ({ pkgs, lib, ... }:
let
  domain = "sourcehut.localdomain";
in
{
  name = "sourcehut";

  meta.maintainers = with pkgs.lib.maintainers; [ tomberek nessdoor ];

  nodes.machine = { config, pkgs, nodes, ... }: {
    imports = [
      ./nodes/common.nix
    ];

    networking.domain = domain;
    networking.extraHosts = ''
      ${config.networking.primaryIPAddress} builds.${domain}
      ${config.networking.primaryIPAddress} meta.${domain}
    '';

    services.sourcehut = {
      builds = {
        enable = true;
        # FIXME: see why it does not seem to activate fully.
        #enableWorker = true;
        images = { };
      };

      settings."builds.sr.ht" = {
        oauth-client-secret = pkgs.writeText "buildsrht-oauth-client-secret" "2260e9c4d9b8dcedcef642860e0504bc";
        oauth-client-id = "299db9f9c2013170";
      };
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    with subtest("Check whether meta comes up"):
         machine.wait_for_unit("metasrht-api.service")
         machine.wait_for_unit("metasrht.service")
         machine.wait_for_unit("metasrht-webhooks.service")
         machine.wait_for_open_port(5000)
         machine.succeed("curl -sL http://localhost:5000 | grep meta.${domain}")
         machine.succeed("curl -sL http://meta.${domain} | grep meta.${domain}")

    with subtest("Check whether builds comes up"):
         machine.wait_for_unit("buildsrht.service")
         machine.wait_for_open_port(5002)
         machine.succeed("curl -sL http://localhost:5002 | grep builds.${domain}")
         #machine.wait_for_unit("buildsrht-worker.service")
  '';
})
