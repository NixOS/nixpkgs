import ./make-test-python.nix ({ pkgs, ... }:

  let
    inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;

    initialRootPassword = "notproduction";
    aliceProjectName = "project";
    aliceUserId = "2";
    alicePassword = "R5twyCgU0uXC71wT9BBTCqLs6HFZ7h3L";
    aliceUsername = "alice";
  in {
    name = "flake-auto-upgrade";
    meta = with pkgs.lib.maintainers; { maintainers = [ StillerHarpo ]; };

    nodes = {
      builderHttp = { ... }: {
        services.flakeAutoUpgrade = {
          enable = true;
          remote = "http://gitlab/${aliceUsername}/${aliceProjectName}.git";
          credentials = {
            user = aliceUsername;
            passwordFile = pkgs.writeText "password" alicePassword;
          };
          updateBranch = "update";
          buildAttributes = [ "notused" ];
        };
      };
      builderSsh = { ... }: {
        services.flakeAutoUpgrade = {
          enable = true;
          remote = "gitlab@gitlab:${aliceUsername}/${aliceProjectName}.git";
          ssh = {
            hostKey = snakeOilPublicKey;
            key = pkgs.writeText "id_rsa" snakeOilPrivateKey;
          };
          updateBranch = "update";
          buildAttributes = [ "notused" ];
        };
      };
      gitlab = { ... }:

        {
          # TOTO Use lighttp with gitweb and auth
          services.lighttpd = {
            enable = true;
            gitweb.enable = true;
          };

          services.gitlab = {
            enable = true;

            initialRootPasswordFile =
              pkgs.writeText "rootPassword" initialRootPassword;
            secrets = {
              secretFile = pkgs.writeText "secret" "Aig5zaic";
              otpFile = pkgs.writeText "otpsecret" "Riew9mue";
              dbFile = pkgs.writeText "dbsecret" "we2quaeZ";
              jwsFile = pkgs.runCommand "oidcKeyBase" { }
                "${pkgs.openssl}/bin/openssl genrsa 2048 > $out";
            };
          };
          services.openssh.enable = true;
          users.users.root.openssh.authorizedKeys.keys = [ snakeOilPublicKey ];

          nixpkgs.overlays = [
            (_: prev: {
              # we have to override nix because we can't build
              # anything without a substituter for bootstrapping
              nix = (pkgs.writeShellScriptBin "nix" ''
                case $1 in
                  flake*) echo "newline" >> ./fakeFlake ;;
                  build*)
                    if [ -f failFile ]
                    then
                       exit 0
                    else
                       exit 1
                    fi
                    ;;
                esac
              '').overrideAttrs (_: { version = "2.2"; });

            })
          ];

        };
    };
    testScript = { nodes, ... }:
      let

        createUserAlice = pkgs.writeText "create-user-alice.json"
          (builtins.toJSON rec {
            username = aliceUsername;
            name = username;
            email = "alice@localhost";
            password = alicePassword;
            skip_confirmation = true;
          });
        aliceAddSSHKey = pkgs.writeText "alice-add-ssh-key.json"
          (builtins.toJSON {
            id = aliceUserId;
            title = "snakeoil@nixos";
            key = snakeOilPublicKey;
          });
        aliceAuth = pkgs.writeText "alice-auth.json" (builtins.toJSON {
          grant_type = "password";
          username = aliceUsername;
          password = alicePassword;
        });
        createProjectAlice = pkgs.writeText "create-project-alice.json"
          (builtins.toJSON {
            name = aliceProjectName;
            visibility = "public";
          });

        # Wait for all GitLab services to be fully started.
        waitForServices = ''
          gitlab.wait_for_unit("gitaly.service")
          gitlab.wait_for_unit("gitlab-workhorse.service")
          # https://github.com/NixOS/nixpkgs/issues/132295
          # gitlab.wait_for_unit("gitlab-pages.service")
          gitlab.wait_for_unit("gitlab.service")
          gitlab.wait_for_unit("gitlab-sidekiq.service")
          gitlab.wait_for_file("${nodes.gitlab.config.services.gitlab.statePath}/tmp/sockets/gitlab.socket")
          gitlab.wait_until_succeeds("curl -sSf http://gitlab/users/sign_in")
        '';

      in ''
        ${waitForServices}
        gitlab.succeed(
           """[ "$(curl -o /dev/null -w '%{http_code}' -X POST -H 'Content-Type: application/json' -H @/tmp/headers -d @${createUserAlice} http://gitlab/api/v4/users)" = "201" ]"""
        )
        gitlab.succeed(
               "echo \"Authorization: Bearer $(curl -X POST -H 'Content-Type: application/json' -d @${aliceAuth} http://gitlab/oauth/token | ${pkgs.jq}/bin/jq -r '.access_token')\" >/tmp/headers-alice"
           )
        gitlab.succeed(
            """
            [ "$(curl \
                -o /dev/null \
                -w '%{http_code}' \
                -X POST \
                -H 'Content-Type: application/json' \
                -H @/tmp/headers-alice -d @${aliceAddSSHKey} \
                http://gitlab/api/v4/user/keys)" = "201" ]
            """
            )

        # Alice creates a new repository
        gitlab.succeed(
            """
            [ "$(curl \
                -o /dev/null \
                -w '%{http_code}' \
                -X POST \
                -H 'Content-Type: application/json' \
                -H @/tmp/headers-alice \
                -d @${createProjectAlice} \
                http://gitlab/api/v4/projects)" = "201" ]
            """
        )
        gitlab.succeed(
            """git clone http://gitlab/${aliceUsername}/${aliceProjectName}.git project""",
            timeout=15
        )
        gitlab.succeed("cd project")
        builderSsh.systemctl("start flake-auto-upgrade")
        builderSsh.wait_for_unit("flake-auto-upgrade")
        gitlab.fail("stat fakeFlake")
        # flake is added
        gitlab.succeed("stat fakeFlake")
        gitlab.succeed("cp fakeFlake ..")
        builderHttp.systemctl("start flake-auto-upgrade")
        builderHttp.wait_for_unit("flake-auto-upgrade")
        # flake is changed again
        gitlab.fail("diff fakeFlake ../fakeFlake")
      '';
  })
