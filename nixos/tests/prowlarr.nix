{
  runTest,
  dataDir,
}:

runTest

  (
    { lib, ... }:

    {
      name = "prowlarr";
      meta.maintainers = with lib.maintainers; [ ];

      nodes.machine =
        { pkgs, ... }:
        {
          services.prowlarr = {
            enable = true;
            inherit dataDir;
          };
        };

      testScript = ''
        machine.wait_for_unit("prowlarr.service")
        machine.wait_for_open_port(9696)
        response = machine.succeed("curl --fail http://localhost:9696/")
        assert '<title>Prowlarr</title>' in response, "Login page didn't load successfully"
        machine.succeed("[ -d ${dataDir} ]")
        # Check that we're using a bind mount when using a non-default dataDir
        ${lib.optionalString (
          dataDir != "/var/lib/prowlarr"
        ) ''machine.succeed("findmnt /var/lib/private/prowlarr | grep ${dataDir}")''}
      '';
    }
  )
