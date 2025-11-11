{
  lib,
  pkgs,
  ...
}:

{
  name = "froide-food";
  meta.maintainers = with lib.maintainers; [ onny ];

  nodes = {
    machine = {
      virtualisation.memorySize = 2048;
      services.froide-food.enable = true;
    };
  };

  testScript =
    let
      changePassword = pkgs.writeText "change-password.py" ''
        from django.contrib.auth.models import User
        u = User.objects.get(username='food')
        u.set_password('food')
        u.save()
      '';
    in
    ''
      start_all()
      machine.wait_for_unit("froide-food.service")
      machine.wait_for_file("/run/froide-food/froide-food.socket")

      with subtest("Home screen loads"):
          machine.succeed(
              "curl -sSfL http://[::1]:80 | grep '<title>django CMS</title>'"
          )

      with subtest("Superuser can be created"):
          machine.succeed(
              "froide-food createsuperuser --noinput --username food --email food@example.com"
          )
          # Django doesn't have a "clean" way of inputting the password from the command line
          machine.succeed("cat '${changePassword}' | froide-food shell")
    '';
}
