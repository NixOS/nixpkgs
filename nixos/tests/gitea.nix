{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  supportedDbTypes = [ "mysql" "postgres" "sqlite3" ];
  makeGiteaTest = type: nameValuePair type (makeTest {
    name = "gitea-${type}";
    meta.maintainers = with maintainers; [ aanderse kolaente ma27 ];
    machine = { config, pkgs, ... }: {
      services.gitea = {
        enable = true;
        database = { inherit type; };
        disableRegistration = true;
      };
    };

    testScript = ''
      start_all()

      machine.wait_for_unit("gitea.service")
      machine.wait_for_open_port(3000)
      machine.succeed("curl --fail http://localhost:3000/")
      machine.succeed(
          "curl --fail http://localhost:3000/user/sign_up | grep 'Registration is disabled. Please contact your site administrator.'"
      )
    '';
  });
in

listToAttrs (map makeGiteaTest supportedDbTypes)
