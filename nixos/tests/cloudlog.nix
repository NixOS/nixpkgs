{ pkgs, ... }:
{
  name = "cloudlog";
<<<<<<< HEAD
=======
  meta = {
    maintainers = with pkgs.lib.maintainers; [ melling ];
  };
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
