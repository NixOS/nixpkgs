import ../make-test-python.nix (
  { lib, pkgs, ... }:
  {
    name = "froide-govplan";
    meta.maintainers = with lib.maintainers; [ onny ];

    nodes.machine =
      { config, ... }:
      {
        virtualisation.memorySize = 2048;
        services.froide-govplan.enable = true;
      };

    testScript =
      let
        changePassword = pkgs.writeText "change-password.py" ''
          from users.models import User
          u = User.objects.get(username='govplan')
          u.set_password('govplan')
          u.save()
        '';
      in
      ''
        start_all()
        machine.wait_for_unit("froide-govplan.service")

        with subtest("Home screen loads"):
            machine.succeed(
                "curl -sSfL http://[::1]:8080 | grep '<title>Home | NetBox</title>'"
            )

        with subtest("Superuser can be created"):
            machine.succeed(
                "froide-govplan createsuperuser --noinput --username govplan --email govplan@example.com"
            )
            # Django doesn't have a "clean" way of inputting the password from the command line
            machine.succeed("cat '${changePassword}' | netbox-manage shell")
      '';
  }
)
