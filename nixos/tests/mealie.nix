{ pkgs, ... }:

{
  name = "mealie";
  meta = with pkgs.lib.maintainers; {
    maintainers = [
      litchipi
      anoa
    ];
  };

  nodes =
    let
      sqlite = {
        services.mealie = {
          enable = true;
          port = 9001;
        };
      };
      postgres = {
        imports = [ sqlite ];
        services.mealie.database.createLocally = true;
      };
    in
    {
      inherit sqlite postgres;
    };

  testScript = ''
    start_all()

    def test_mealie(node):
      node.wait_for_unit("mealie.service")
      node.wait_for_open_port(9001)
      node.succeed("curl --fail http://localhost:9001")

    test_mealie(sqlite)
    sqlite.send_monitor_command("quit")
    sqlite.wait_for_shutdown()
    test_mealie(postgres)
  '';
}
