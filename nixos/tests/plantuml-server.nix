import ./make-test-python.nix (
  { pkgs, lib, ... }:
  {
    name = "plantuml-server";
    meta.maintainers = with lib.maintainers; [ anthonyroussel ];

    nodes.machine =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.curl ];
        services.plantuml-server.enable = true;
      };

    testScript = ''
      start_all()

      machine.wait_for_unit("plantuml-server.service")
      machine.wait_for_open_port(8080)

      with subtest("Generate chart"):
        chart_id = machine.succeed("curl -sSf http://localhost:8080/plantuml/coder -d 'Alice -> Bob'")
        machine.succeed("curl -sSf http://localhost:8080/plantuml/txt/{}".format(chart_id))
    '';
  }
)
