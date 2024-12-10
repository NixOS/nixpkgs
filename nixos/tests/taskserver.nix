import ./make-test-python.nix (
  { pkgs, ... }:
  let
    snakeOil =
      pkgs.runCommand "snakeoil-certs"
        {
          outputs = [
            "out"
            "cacert"
            "cert"
            "key"
            "crl"
          ];
          buildInputs = [ pkgs.gnutls.bin ];
          caTemplate = pkgs.writeText "snakeoil-ca.template" ''
            cn = server
            expiration_days = -1
            cert_signing_key
            ca
          '';
          certTemplate = pkgs.writeText "snakeoil-cert.template" ''
            cn = server
            expiration_days = -1
            tls_www_server
            encryption_key
            signing_key
          '';
          crlTemplate = pkgs.writeText "snakeoil-crl.template" ''
            expiration_days = -1
          '';
          userCertTemplate = pkgs.writeText "snakeoil-user-cert.template" ''
            organization = snakeoil
            cn = server
            expiration_days = -1
            tls_www_client
            encryption_key
            signing_key
          '';
        }
        ''
          certtool -p --bits 4096 --outfile ca.key
          certtool -s --template "$caTemplate" --load-privkey ca.key \
                      --outfile "$cacert"
          certtool -p --bits 4096 --outfile "$key"
          certtool -c --template "$certTemplate" \
                      --load-ca-privkey ca.key \
                      --load-ca-certificate "$cacert" \
                      --load-privkey "$key" \
                      --outfile "$cert"
          certtool --generate-crl --template "$crlTemplate" \
                                  --load-ca-privkey ca.key \
                                  --load-ca-certificate "$cacert" \
                                  --outfile "$crl"

          mkdir "$out"

          # Stripping key information before the actual PEM-encoded values is solely
          # to make test output a bit less verbose when copying the client key to the
          # actual client.
          certtool -p --bits 4096 | sed -n \
            -e '/^----* *BEGIN/,/^----* *END/p' > "$out/alice.key"

          certtool -c --template "$userCertTemplate" \
                      --load-privkey "$out/alice.key" \
                      --load-ca-privkey ca.key \
                      --load-ca-certificate "$cacert" \
                      --outfile "$out/alice.cert"
        '';

  in
  {
    name = "taskserver";

    nodes = rec {
      server = {
        services.taskserver.enable = true;
        services.taskserver.listenHost = "::";
        services.taskserver.openFirewall = true;
        services.taskserver.fqdn = "server";
        services.taskserver.organisations = {
          testOrganisation.users = [
            "alice"
            "foo"
          ];
          anotherOrganisation.users = [ "bob" ];
        };

        specialisation.manual-config.configuration = {
          services.taskserver.pki.manual = {
            ca.cert = snakeOil.cacert;
            server.cert = snakeOil.cert;
            server.key = snakeOil.key;
            server.crl = snakeOil.crl;
          };
        };
      };

      client1 =
        { pkgs, ... }:
        {
          environment.systemPackages = [
            pkgs.taskwarrior
            pkgs.gnutls
          ];
          users.users.alice.isNormalUser = true;
          users.users.bob.isNormalUser = true;
          users.users.foo.isNormalUser = true;
          users.users.bar.isNormalUser = true;
        };

      client2 = client1;
    };

    testScript =
      { nodes, ... }:
      let
        cfg = nodes.server.config.services.taskserver;
        portStr = toString cfg.listenPort;
        specialisations = "${nodes.server.system.build.toplevel}/specialisation";
        newServerSystem = "${specialisations}/manual-config";
        switchToNewServer = "${newServerSystem}/bin/switch-to-configuration test";
      in
      ''
        from shlex import quote


        def su(user, cmd):
            return f"su - {user} -c {quote(cmd)}"


        def no_extra_init(client, org, user):
            pass


        def setup_clients_for(org, user, extra_init=no_extra_init):
            for client in [client1, client2]:
                with client.nested(f"initialize client for user {user}"):
                    client.succeed(
                        su(user, f"rm -rf /home/{user}/.task"),
                        su(user, "task rc.confirmation=no config confirmation no"),
                    )

                    exportinfo = server.succeed(f"nixos-taskserver user export {org} {user}")

                    with client.nested("importing taskwarrior configuration"):
                        client.succeed(su(user, f"eval {quote(exportinfo)} >&2"))

                    extra_init(client, org, user)

                    client.succeed(su(user, "task config taskd.server server:${portStr} >&2"))

                    client.succeed(su(user, "task sync init >&2"))


        def restart_server():
            server.systemctl("restart taskserver.service")
            server.wait_for_open_port(${portStr})


        def re_add_imperative_user():
            with server.nested("(re-)add imperative user bar"):
                server.execute("nixos-taskserver org remove imperativeOrg")
                server.succeed(
                    "nixos-taskserver org add imperativeOrg",
                    "nixos-taskserver user add imperativeOrg bar",
                )
                setup_clients_for("imperativeOrg", "bar")


        def test_sync(user):
            with subtest(f"sync for user {user}"):
                client1.succeed(su(user, "task add foo >&2"))
                client1.succeed(su(user, "task sync >&2"))
                client2.fail(su(user, "task list >&2"))
                client2.succeed(su(user, "task sync >&2"))
                client2.succeed(su(user, "task list >&2"))


        def check_client_cert(user):
            # debug level 3 is a workaround for gnutls issue https://gitlab.com/gnutls/gnutls/-/issues/1040
            cmd = (
                f"gnutls-cli -d 3"
                f" --x509cafile=/home/{user}/.task/keys/ca.cert"
                f" --x509keyfile=/home/{user}/.task/keys/private.key"
                f" --x509certfile=/home/{user}/.task/keys/public.cert"
                f" --port=${portStr} server < /dev/null"
            )
            return su(user, cmd)


        # Explicitly start the VMs so that we don't accidentally start newServer
        server.start()
        client1.start()
        client2.start()

        server.wait_for_unit("taskserver.service")

        server.succeed(
            "nixos-taskserver user list testOrganisation | grep -qxF alice",
            "nixos-taskserver user list testOrganisation | grep -qxF foo",
            "nixos-taskserver user list anotherOrganisation | grep -qxF bob",
        )

        server.wait_for_open_port(${portStr})

        client1.wait_for_unit("multi-user.target")
        client2.wait_for_unit("multi-user.target")

        setup_clients_for("testOrganisation", "alice")
        setup_clients_for("testOrganisation", "foo")
        setup_clients_for("anotherOrganisation", "bob")

        for user in ["alice", "bob", "foo"]:
            test_sync(user)

        server.fail("nixos-taskserver user add imperativeOrg bar")
        re_add_imperative_user()

        test_sync("bar")

        with subtest("checking certificate revocation of user bar"):
            client1.succeed(check_client_cert("bar"))

            server.succeed("nixos-taskserver user remove imperativeOrg bar")
            restart_server()

            client1.fail(check_client_cert("bar"))

            client1.succeed(su("bar", "task add destroy everything >&2"))
            client1.fail(su("bar", "task sync >&2"))

        re_add_imperative_user()

        with subtest("checking certificate revocation of org imperativeOrg"):
            client1.succeed(check_client_cert("bar"))

            server.succeed("nixos-taskserver org remove imperativeOrg")
            restart_server()

            client1.fail(check_client_cert("bar"))

            client1.succeed(su("bar", "task add destroy even more >&2"))
            client1.fail(su("bar", "task sync >&2"))

        re_add_imperative_user()

        with subtest("check whether declarative config overrides user bar"):
            restart_server()
            test_sync("bar")


        def init_manual_config(client, org, user):
            cfgpath = f"/home/{user}/.task"

            client.copy_from_host(
                "${snakeOil.cacert}",
                f"{cfgpath}/ca.cert",
            )
            for file in ["alice.key", "alice.cert"]:
                client.copy_from_host(
                    f"${snakeOil}/{file}",
                    f"{cfgpath}/{file}",
                )

            for file in [f"{user}.key", f"{user}.cert"]:
                client.copy_from_host(
                    f"${snakeOil}/{file}",
                    f"{cfgpath}/{file}",
                )

            client.succeed(
                su("alice", f"task config taskd.ca {cfgpath}/ca.cert"),
                su("alice", f"task config taskd.key {cfgpath}/{user}.key"),
                su(user, f"task config taskd.certificate {cfgpath}/{user}.cert"),
            )


        with subtest("check manual configuration"):
            # Remove the keys from automatic CA creation, to make sure the new
            # generation doesn't use keys from before.
            server.succeed("rm -rf ${cfg.dataDir}/keys/* >&2")

            server.succeed(
                "${switchToNewServer} >&2"
            )
            server.wait_for_unit("taskserver.service")
            server.wait_for_open_port(${portStr})

            server.succeed(
                "nixos-taskserver org add manualOrg",
                "nixos-taskserver user add manualOrg alice",
            )

            setup_clients_for("manualOrg", "alice", init_manual_config)

            test_sync("alice")
      '';
  }
)
