{
  name = "zeroclaw";

  nodes.machine = {
    services.zeroclaw = {
      enable = true;
      settings = {
        default_provider = "ollama";
        default_model = "llama3.2";
      };
    };
  };

  testScript =
    { nodes, ... }:
    let
      host = nodes.machine.services.zeroclaw.host;
      port = nodes.machine.services.zeroclaw.port;
    in
    # python
    ''
      machine.wait_for_unit("zeroclaw.service")
      machine.wait_for_open_port(${toString port})

      response = machine.succeed("curl -sf http://${host}:${toString port}/")
      assert "ZeroClaw" in response, f"Expected the ZeroClaw web interface to be served: {response}"
    '';
}
