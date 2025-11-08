{ ... }:
{
  name = "paisa";
  nodes.serviceEmptyConf =
    { ... }:
    {
      services.paisa = {
        enable = true;

        settings = { };
      };
    };

  testScript = ''
    start_all()

    machine.systemctl("start network-online.target")
    machine.wait_for_unit("network-online.target")

    with subtest("empty/default config test"):
      serviceEmptyConf.wait_for_unit("paisa.service")
      serviceEmptyConf.wait_for_open_port(7500)

      serviceEmptyConf.succeed("curl --location --fail http://localhost:7500")
  '';
}
