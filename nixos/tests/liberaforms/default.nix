{
  lib,
  ...
}:

{
  name = "liberaforms";
  meta.maintainers = lib.teams.ngi.members;

  nodes = {
    machine =
      { pkgs, ... }:
      {
        imports = [ ./example.nix ];
      };
  };

  testScript =
    { nodes, ... }:
    let
      cfg = nodes.machine.services.liberaforms;
    in
    # python
    ''
      start_all()
      machine.wait_for_unit("multi-user.target")

      machine.wait_for_unit("liberaforms.service")
      machine.wait_until_succeeds("curl --fail http://0.0.0.0:${toString cfg.port}/")

      machine.wait_for_unit("nginx.service")
      machine.wait_until_succeeds(
          "curl --fail --resolve liberaforms.test:80:127.0.0.1 ${cfg.settings.BASE_URL}"
      )
      machine.succeed(
          "curl -sI --resolve liberaforms.test:80:127.0.0.1 ${cfg.settings.BASE_URL}"
          " | grep -qi 'x-frame-options: SAMEORIGIN'"
      )
    '';

  # Debug interactively with:
  # - nix run -f . nixosTests.liberaforms.driverInteractive -L
  # - run_tests()
  interactive.sshBackdoor.enable = true;
  interactive.nodes.machine =
    { config, ... }:
    {
      virtualisation.forwardPorts = [
        {
          from = "host";
          host = config.services.liberaforms.port;
          guest = config.services.liberaforms.port;
        }
      ];
    };
}
