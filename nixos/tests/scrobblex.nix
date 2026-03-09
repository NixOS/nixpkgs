{ lib, ... }:
{
  name = "scrobblex";
  meta.maintainers = with lib.maintainers; [ msaxena ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.scrobblex = {
        enable = true;
        port = 3090;
        # Provide dummy credentials via an environment file so the service
        # starts without network access.  The OAuth flow will not work with
        # these values, but the /healthcheck endpoint does not require it.
        environmentFile = pkgs.writeText "scrobblex-env" ''
          TRAKT_ID=test-client-id
          TRAKT_SECRET=test-client-secret
        '';
      };
    };

  testScript = ''
    machine.wait_for_unit("scrobblex.service")
    machine.wait_for_open_port(3090)
    response = machine.succeed("curl -sf http://localhost:3090/healthcheck")
    import json
    data = json.loads(response)
    assert data["message"] == "OK", f"unexpected healthcheck response: {data}"
  '';
}
