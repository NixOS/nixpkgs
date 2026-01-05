{ lib, config, ... }:

{
  name = "prowlarr";
  meta.maintainers = [ ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.prowlarr.enable = true;
      specialisation.customDataDir = {
        inheritParentConfig = true;
        configuration.services.prowlarr.dataDir = "/srv/prowlarr";
      };
    };

  testScript = ''
    def verify_prowlarr_works():
      machine.wait_for_unit("prowlarr.service")
      machine.wait_for_open_port(9696)
      response = machine.succeed("curl --fail http://localhost:9696/")
      assert '<title>Prowlarr</title>' in response, "Login page didn't load successfully"
      machine.succeed("[ -d /var/lib/prowlarr ]")

    with subtest("Prowlarr starts and responds to requests"):
      verify_prowlarr_works()

    with subtest("Prowlarr data directory migration works"):
      machine.systemctl("stop prowlarr.service")
      machine.succeed("mkdir -p /tmp/prowlarr-migration")
      machine.succeed("rsync -a -delete /var/lib/prowlarr/ /tmp/prowlarr-migration")
      machine.succeed("${config.nodes.machine.system.build.toplevel}/specialisation/customDataDir/bin/switch-to-configuration test")
      machine.wait_for_unit("var-lib-private-prowlarr.mount")
      machine.succeed("rsync -a -delete /tmp/prowlarr-migration/ /var/lib/prowlarr")
      machine.systemctl("restart prowlarr.service")
      # Check that we're using a bind mount when using a non-default dataDir
      machine.succeed("findmnt /var/lib/private/prowlarr | grep /srv/prowlarr")
      verify_prowlarr_works()
  '';
}
