{ system ? builtins.currentSystem
, config ? { }
, pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  ## gpg --faked-system-time='20230301T010000!' --quick-generate-key snakeoil ed25519 sign
  signingPrivateKey = ''
    -----BEGIN PGP PRIVATE KEY BLOCK-----

    lFgEY/6jkBYJKwYBBAHaRw8BAQdADXiZRV8RJUyC9g0LH04wLMaJL9WTc+szbMi7
    5fw4yP8AAQCl8EwGfzSLm/P6fCBfA3I9znFb3MEHGCCJhJ6VtKYyRw7ktAhzbmFr
    ZW9pbIiUBBMWCgA8FiEE+wUM6VW/NLtAdSixTWQt6LZ4x50FAmP+o5ACGwMFCQPC
    ZwAECwkIBwQVCgkIBRYCAwEAAh4FAheAAAoJEE1kLei2eMedFTgBAKQs1oGFZrCI
    TZP42hmBTKxGAI1wg7VSdDEWTZxut/2JAQDGgo2sa4VHMfj0aqYGxrIwfP2B7JHO
    GCqGCRf9O/hzBA==
    =9Uy3
    -----END PGP PRIVATE KEY BLOCK-----
  '';
  signingPrivateKeyId = "4D642DE8B678C79D";

  actionsWorkflowYaml = ''
    run-name: dummy workflow
    on:
      push:
    jobs:
      cat:
        runs-on: native
        steps:
          - uses: http://localhost:3000/test/checkout@main
          - run: cat testfile
  '';
  # https://github.com/actions/checkout/releases
  checkoutActionSource = pkgs.fetchFromGitHub {
    owner = "actions";
    repo = "checkout";
    rev = "v4.1.1";
    hash = "sha256-h2/UIp8IjPo3eE4Gzx52Fb7pcgG/Ww7u31w5fdKVMos=";
  };

  metricSecret = "fakesecret";

  supportedDbTypes = [ "mysql" "postgres" "sqlite3" ];
  makeForgejoTest = type: nameValuePair type (makeTest {
    name = "forgejo-${type}";
    meta.maintainers = with maintainers; [ bendlas emilylange ];

    nodes = {
      server = { config, pkgs, ... }: {
        virtualisation.memorySize = 2047;
        services.forgejo = {
          enable = true;
          database = { inherit type; };
          settings.service.DISABLE_REGISTRATION = true;
          settings."repository.signing".SIGNING_KEY = signingPrivateKeyId;
          settings.actions.ENABLED = true;
          settings.repository = {
            ENABLE_PUSH_CREATE_USER = true;
            DEFAULT_PUSH_CREATE_PRIVATE = false;
          };
          settings.metrics.ENABLED = true;
          secrets.metrics.TOKEN = pkgs.writeText "metrics_secret" metricSecret;
        };
        environment.systemPackages = [ config.services.forgejo.package pkgs.gnupg pkgs.jq pkgs.file pkgs.htmlq ];
        services.openssh.enable = true;

        specialisation.runner = {
          inheritParentConfig = true;
          configuration.services.gitea-actions-runner = {
            package = pkgs.forgejo-runner;
            instances."test" = {
              enable = true;
              name = "ci";
              url = "http://localhost:3000";
              labels = [
                # type ":host" does not depend on docker/podman/lxc
                "native:host"
              ];
              tokenFile = "/var/lib/forgejo/runner_token";
            };
          };
        };
        specialisation.dump = {
          inheritParentConfig = true;
          configuration.services.forgejo.dump = {
            enable = true;
            type = "tar.zst";
            file = "dump.tar.zst";
          };
        };
      };
      client = { ... }: {
        programs.git = {
          enable = true;
          config = {
            user.email = "test@localhost";
            user.name = "test";
            init.defaultBranch = "main";
          };
        };
        programs.ssh.extraConfig = ''
          Host *
            StrictHostKeyChecking no
            IdentityFile ~/.ssh/privk
        '';
      };
    };

    testScript = { nodes, ... }:
      let
        inherit (import ./ssh-keys.nix pkgs) snakeOilPrivateKey snakeOilPublicKey;
        serverSystem = nodes.server.system.build.toplevel;
        dumpFile = with nodes.server.specialisation.dump.configuration.services.forgejo.dump; "${backupDir}/${file}";
        remoteUri = "forgejo@server:test/repo";
        remoteUriCheckoutAction = "forgejo@server:test/checkout";
      in
      ''
        import json

        start_all()

        client.succeed("mkdir -p ~/.ssh")
        client.succeed("(umask 0077; cat ${snakeOilPrivateKey} > ~/.ssh/privk)")

        client.succeed("mkdir /tmp/repo")
        client.succeed("git -C /tmp/repo init")
        client.succeed("echo 'hello world' > /tmp/repo/testfile")
        client.succeed("git -C /tmp/repo add .")
        client.succeed("git -C /tmp/repo commit -m 'Initial import'")
        client.succeed("git -C /tmp/repo remote add origin ${remoteUri}")

        server.wait_for_unit("forgejo.service")
        server.wait_for_open_port(3000)
        server.wait_for_open_port(22)
        server.succeed("curl --fail http://localhost:3000/")

        server.succeed(
            "su -l forgejo -c 'gpg --homedir /var/lib/forgejo/data/home/.gnupg "
            + "--import ${toString (pkgs.writeText "forgejo.key" signingPrivateKey)}'"
        )

        assert "BEGIN PGP PUBLIC KEY BLOCK" in server.succeed("curl http://localhost:3000/api/v1/signing-key.gpg")

        api_version = json.loads(server.succeed("curl http://localhost:3000/api/forgejo/v1/version")).get("version")
        assert "development" != api_version and "${pkgs.forgejo.version}+gitea-" in api_version, (
            "/api/forgejo/v1/version should not return 'development' "
            + f"but should contain a forgejo+gitea compatibility version string. Got '{api_version}' instead."
        )

        server.succeed(
            "curl --fail http://localhost:3000/user/sign_up | grep 'Registration is disabled. "
            + "Please contact your site administrator.'"
        )
        server.succeed(
            "su -l forgejo -c 'GITEA_WORK_DIR=/var/lib/forgejo gitea admin user create "
            + "--username test --password totallysafe --email test@localhost --must-change-password=false'"
        )

        api_token = server.succeed(
            "curl --fail -X POST http://test:totallysafe@localhost:3000/api/v1/users/test/tokens "
            + "-H 'Accept: application/json' -H 'Content-Type: application/json' -d "
            + "'{\"name\":\"token\",\"scopes\":[\"all\"]}' | jq '.sha1' | xargs echo -n"
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

        client.succeed("git -C /tmp/repo push origin main")

        client.succeed("git clone ${remoteUri} /tmp/repo-clone")
        print(client.succeed("ls -lash /tmp/repo-clone"))
        assert "hello world" == client.succeed("cat /tmp/repo-clone/testfile").strip()

        with subtest("Testing git protocol version=2 over ssh"):
            git_protocol = client.succeed("GIT_TRACE2_EVENT=true git -C /tmp/repo-clone fetch |& grep negotiated-version")
            version = json.loads(git_protocol).get("value")
            assert version == "2", f"git did not negotiate protocol version 2, but version {version} instead."

        server.wait_until_succeeds(
            'test "$(curl http://localhost:3000/api/v1/repos/test/repo/commits '
            + '-H "Accept: application/json" | jq length)" = "1"',
            timeout=10
        )

        with subtest("Testing /metrics endpoint with token from cfg.secrets"):
            server.fail("curl --fail http://localhost:3000/metrics")
            server.succeed('curl --fail http://localhost:3000/metrics -H "Authorization: Bearer ${metricSecret}"')

        with subtest("Testing runner registration and action workflow"):
            server.succeed(
                "su -l forgejo -c 'GITEA_WORK_DIR=/var/lib/forgejo gitea actions generate-runner-token' | sed 's/^/TOKEN=/' | tee /var/lib/forgejo/runner_token"
            )
            server.succeed("${serverSystem}/specialisation/runner/bin/switch-to-configuration test")
            server.wait_for_unit("gitea-runner-test.service")
            server.succeed("journalctl -o cat -u gitea-runner-test.service | grep -q 'Runner registered successfully'")

            # enable actions feature for this repository, defaults to disabled
            server.succeed(
                "curl --fail -X PATCH http://localhost:3000/api/v1/repos/test/repo "
                + "-H 'Accept: application/json' -H 'Content-Type: application/json' "
                + f"-H 'Authorization: token {api_token}'"
                + ' -d \'{"has_actions":true}\'''
            )

            # mirror "actions/checkout" action
            client.succeed("cp -R ${checkoutActionSource}/ /tmp/checkout")
            client.succeed("git -C /tmp/checkout init")
            client.succeed("git -C /tmp/checkout add .")
            client.succeed("git -C /tmp/checkout commit -m 'Initial import'")
            client.succeed("git -C /tmp/checkout remote add origin ${remoteUriCheckoutAction}")
            client.succeed("git -C /tmp/checkout push origin main")

            # push workflow to initial repo
            client.succeed("mkdir -p /tmp/repo/.forgejo/workflows")
            client.succeed("cp ${pkgs.writeText "dummy-workflow.yml" actionsWorkflowYaml} /tmp/repo/.forgejo/workflows/")
            client.succeed("git -C /tmp/repo add .")
            client.succeed("git -C /tmp/repo commit -m 'Add dummy workflow'")
            client.succeed("git -C /tmp/repo push origin main")

            def poll_workflow_action_status(_) -> bool:
                output = server.succeed(
                    "curl --fail http://localhost:3000/test/repo/actions | "
                    + 'htmlq ".flex-item-leading span" --attribute "data-tooltip-content"'
                ).strip()

                # values taken from https://codeberg.org/forgejo/forgejo/src/commit/af47c583b4fb3190fa4c4c414500f9941cc02389/options/locale/locale_en-US.ini#L3649-L3661
                if output in [ "Failure", "Canceled", "Skipped", "Blocked" ]:
                    raise Exception(f"Workflow status is '{output}', which we consider failed.")
                    server.log(f"Command returned '{output}', which we consider failed.")

                elif output in [ "Unknown", "Waiting", "Running", "" ]:
                    server.log(f"Workflow status is '{output}'. Waiting some more...")
                    return False

                elif output in [ "Success" ]:
                    return True

                raise Exception(f"Workflow status is '{output}', which we don't know. Value mappings likely need updating.")

            with server.nested("Waiting for the workflow run to be successful"):
                retry(poll_workflow_action_status)

        with subtest("Testing backup service"):
            server.succeed("${serverSystem}/specialisation/dump/bin/switch-to-configuration test")
            server.systemctl("start forgejo-dump")
            assert "Zstandard compressed data" in server.succeed("file ${dumpFile}")
            server.copy_from_vm("${dumpFile}")
      '';
  });
in

listToAttrs (map makeForgejoTest supportedDbTypes)
