{
  lib,
  pkgs,
  ...
}:

{
  name = "froide-govplan";
  meta.maintainers = with lib.maintainers; [ onny ];

  nodes = {
    machine = {
      virtualisation.memorySize = 2048;
      services.froide-govplan.enable = true;
    };
  };

  testScript =
    let
      changePassword = pkgs.writeText "change-password.py" ''
        from django.contrib.auth.models import User
        u = User.objects.get(username='govplan')
        u.set_password('govplan')
        u.save()
      '';
    in
    ''
      start_all()
      machine.wait_for_unit("froide-govplan.service")
      machine.wait_for_file("/run/froide-govplan/froide-govplan.socket")

      with subtest("Home screen loads"):
          machine.succeed(
              "curl -sSfL http://[::1]:80 | grep '<title>django CMS</title>'"
          )

      with subtest("Superuser can be created"):
          machine.succeed(
              "froide-govplan createsuperuser --noinput --username govplan --email govplan@example.com"
          )
          # Django doesn't have a "clean" way of inputting the password from the command line
          machine.succeed("cat '${changePassword}' | froide-govplan shell")
    '';
}
