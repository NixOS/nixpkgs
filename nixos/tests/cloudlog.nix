{ pkgs, ... }:
{
  name = "cloudlog";
  meta = {
    maintainers = with pkgs.lib.maintainers; [ melling ];
  };
  nodes = {
    machine = {
      services.mysql.package = pkgs.mariadb;
      services.cloudlog.enable = true;
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("phpfpm-cloudlog")
    machine.wait_for_open_port(80);
    machine.wait_until_succeeds("curl -s -L --fail http://localhost | grep 'Login - Cloudlog'")
  '';
}
