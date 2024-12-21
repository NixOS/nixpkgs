import ./make-test-python.nix (
  { lib, pkgs, ... }:

  {
    name = "davis";

    meta.maintainers = pkgs.davis.meta.maintainers;

    nodes.machine =
      { config, ... }:
      {
        virtualisation = {
          memorySize = 512;
        };

        services.davis = {
          enable = true;
          hostname = "davis.example.com";
          database = {
            driver = "postgresql";
          };
          mail = {
            dsnFile = "${pkgs.writeText "davisMailDns" "smtp://username:password@example.com:25"}";
            inviteFromAddress = "dav@example.com";
          };
          adminLogin = "admin";
          appSecretFile = "${pkgs.writeText "davisAppSecret" "52882ef142066e09ab99ce816ba72522e789505caba224"}";
          adminPasswordFile = "${pkgs.writeText "davisAdminPass" "nixos"}";
          nginx = { };
        };
      };

    testScript = ''
      start_all()
      machine.wait_for_unit("postgresql.service")
      machine.wait_for_unit("davis-env-setup.service")
      machine.wait_for_unit("davis-db-migrate.service")
      machine.wait_for_unit("nginx.service")
      machine.wait_for_unit("phpfpm-davis.service")

      with subtest("welcome screen loads"):
          machine.succeed(
              "curl -sSfL --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/ | grep '<title>Davis</title>'"
          )

      with subtest("login works"):
          csrf_token = machine.succeed(
              "curl -c /tmp/cookies -sSfL --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/login | grep '_csrf_token' | sed -E 's,.*value=\"(.*)\".*,\\1,g'"
          )
          r = machine.succeed(
              f"curl -b /tmp/cookies --resolve davis.example.com:80:127.0.0.1 http://davis.example.com/login -X POST -F username=admin -F password=nixos -F _csrf_token={csrf_token.strip()} -D headers"
          )
          print(r)
          machine.succeed(
            "[[ $(grep -i 'location: ' headers | cut -d: -f2- | xargs echo) == /dashboard* ]]"
          )
    '';
  }
)
