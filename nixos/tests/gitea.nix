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

    nodes = {
      server = { config, pkgs, ... }: {
        virtualisation.memorySize = 2048;
        services.gitea = {
          enable = true;
          database = { inherit type; };
          disableRegistration = true;
        };
        environment.systemPackages = [ pkgs.gitea pkgs.jq ];
        services.openssh.enable = true;
      };
      client1 = { config, pkgs, ... }: {
        environment.systemPackages = [ pkgs.git ];
      };
      client2 = { config, pkgs, ... }: {
        environment.systemPackages = [ pkgs.git ];
      };
    };

    testScript = let
      inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
    in ''
      GIT_SSH_COMMAND = "ssh -i $HOME/.ssh/privk -o StrictHostKeyChecking=no"
      REPO = "gitea@server:test/repo"
      PRIVK = "${snakeOilPrivateKey}"

      start_all()

      client1.succeed("mkdir /tmp/repo")
      client1.succeed("mkdir -p $HOME/.ssh")
      client1.succeed(f"cat {PRIVK} > $HOME/.ssh/privk")
      client1.succeed("chmod 0400 $HOME/.ssh/privk")
      client1.succeed("git -C /tmp/repo init")
      client1.succeed("echo hello world > /tmp/repo/testfile")
      client1.succeed("git -C /tmp/repo add .")
      client1.succeed("git config --global user.email test@localhost")
      client1.succeed("git config --global user.name test")
      client1.succeed("git -C /tmp/repo commit -m 'Initial import'")
      client1.succeed(f"git -C /tmp/repo remote add origin {REPO}")

      server.wait_for_unit("gitea.service")
      server.wait_for_open_port(3000)
      server.succeed("curl --fail http://localhost:3000/")

      server.succeed(
          "curl --fail http://localhost:3000/user/sign_up | grep 'Registration is disabled. "
          + "Please contact your site administrator.'"
      )
      server.succeed(
          "su -l gitea -c 'GITEA_WORK_DIR=/var/lib/gitea gitea admin user create "
          + "--username test --password totallysafe --email test@localhost'"
      )

      api_token = server.succeed(
          "curl --fail -X POST http://test:totallysafe@localhost:3000/api/v1/users/test/tokens "
          + "-H 'Accept: application/json' -H 'Content-Type: application/json' -d "
          + "'{\"name\":\"token\"}' | jq '.sha1' | xargs echo -n"
      )

      server.succeed(
          "curl --fail -X POST http://localhost:3000/api/v1/user/repos "
          + "-H 'Accept: application/json' -H 'Content-Type: application/json' "
          + f"-H 'Authorization: token {api_token}'"
          + ' -d \'{"auto_init":false, "description":"string", "license":"mit", "name":"repo", "private":false}\'''
      )

      server.succeed(
          "curl --fail -X POST http://localhost:3000/api/v1/user/keys "
          + "-H 'Accept: application/json' -H 'Content-Type: application/json' "
          + f"-H 'Authorization: token {api_token}'"
          + ' -d \'{"key":"${snakeOilPublicKey}","read_only":true,"title":"SSH"}\'''
      )

      client1.succeed(
          f"GIT_SSH_COMMAND='{GIT_SSH_COMMAND}' git -C /tmp/repo push origin master"
      )

      client2.succeed("mkdir -p $HOME/.ssh")
      client2.succeed(f"cat {PRIVK} > $HOME/.ssh/privk")
      client2.succeed("chmod 0400 $HOME/.ssh/privk")
      client2.succeed(f"GIT_SSH_COMMAND='{GIT_SSH_COMMAND}' git clone {REPO}")
      client2.succeed('test "$(cat repo/testfile | xargs echo -n)" = "hello world"')

      server.succeed(
          'test "$(curl http://localhost:3000/api/v1/repos/test/repo/commits '
          + '-H "Accept: application/json" | jq length)" = "1"'
      )

      client1.shutdown()
      client2.shutdown()
      server.shutdown()
    '';
  });
in

listToAttrs (map makeGiteaTest supportedDbTypes)
