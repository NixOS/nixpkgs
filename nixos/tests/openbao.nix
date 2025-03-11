{ pkgs, ... }:
{
  name = "openbao";
  meta = with pkgs.lib.maintainers; {
    maintainers = [ brianmay ];
  };
  nodes.machine =
    { pkgs, ... }:
    {
      environment.variables.VAULT_ADDR = "http://127.0.0.1:8200";
      services.openbao.enable = true;
    };

  testScript = ''
    start_all()

    machine.wait_for_unit("multi-user.target")
    machine.wait_for_unit("openbao.service")
    machine.wait_for_open_port(8200)
    machine.succeed("bao operator init")
    # openbao now returns exit code 2 for sealed openbaos
    machine.fail("bao status")
    machine.succeed("bao status || test $? -eq 2")
  '';
}
