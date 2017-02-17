import ./make-test.nix ({ pkgs, ... }: let
  snakeOil = pkgs.runCommand "snakeoil-certs" {
    outputs = [ "out" "cacert" "cert" "key" "crl" ];
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
    userCertTemplace = pkgs.writeText "snakoil-user-cert.template" ''
      organization = snakeoil
      cn = server
      expiration_days = -1
      tls_www_client
      encryption_key
      signing_key
    '';
  } ''
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

    certtool -c --template "$userCertTemplace" \
                --load-privkey "$out/alice.key" \
                --load-ca-privkey ca.key \
                --load-ca-certificate "$cacert" \
                --outfile "$out/alice.cert"
  '';

in {
  name = "taskserver";

  nodes = rec {
    server = {
      services.taskserver.enable = true;
      services.taskserver.listenHost = "::";
      services.taskserver.fqdn = "server";
      services.taskserver.organisations = {
        testOrganisation.users = [ "alice" "foo" ];
        anotherOrganisation.users = [ "bob" ];
      };
    };

    # New generation of the server with manual config
    newServer = { lib, nodes, ... }: {
      imports = [ server ];
      services.taskserver.pki.manual = {
        ca.cert = snakeOil.cacert;
        server.cert = snakeOil.cert;
        server.key = snakeOil.key;
        server.crl = snakeOil.crl;
      };
      # This is to avoid assigning a different network address to the new
      # generation.
      networking = lib.mapAttrs (lib.const lib.mkForce) {
        inherit (nodes.server.config.networking)
          hostName interfaces primaryIPAddress extraHosts;
      };
    };

    client1 = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.taskwarrior pkgs.gnutls ];
      users.users.alice.isNormalUser = true;
      users.users.bob.isNormalUser = true;
      users.users.foo.isNormalUser = true;
      users.users.bar.isNormalUser = true;
    };

    client2 = client1;
  };

  testScript = { nodes, ... }: let
    cfg = nodes.server.config.services.taskserver;
    portStr = toString cfg.listenPort;
    newServerSystem = nodes.newServer.config.system.build.toplevel;
    switchToNewServer = "${newServerSystem}/bin/switch-to-configuration test";
  in ''
    sub su ($$) {
      my ($user, $cmd) = @_;
      my $esc = $cmd =~ s/'/'\\${"'"}'/gr;
      return "su - $user -c '$esc'";
    }

    sub setupClientsFor ($$;$) {
      my ($org, $user, $extraInit) = @_;

      for my $client ($client1, $client2) {
        $client->nest("initialize client for user $user", sub {
          $client->succeed(
            (su $user, "rm -rf /home/$user/.task"),
            (su $user, "task rc.confirmation=no config confirmation no")
          );

          my $exportinfo = $server->succeed(
            "nixos-taskserver user export $org $user"
          );

          $exportinfo =~ s/'/'\\'''/g;

          $client->nest("importing taskwarrior configuration", sub {
            my $cmd = su $user, "eval '$exportinfo' >&2";
            my ($status, $out) = $client->execute_($cmd);
            if ($status != 0) {
              $client->log("output: $out");
              die "command `$cmd' did not succeed (exit code $status)\n";
            }
          });

          eval { &$extraInit($client, $org, $user) };

          $client->succeed(su $user,
            "task config taskd.server server:${portStr} >&2"
          );

          $client->succeed(su $user, "task sync init >&2");
        });
      }
    }

    sub restartServer {
      $server->succeed("systemctl restart taskserver.service");
      $server->waitForOpenPort(${portStr});
    }

    sub readdImperativeUser {
      $server->nest("(re-)add imperative user bar", sub {
        $server->execute("nixos-taskserver org remove imperativeOrg");
        $server->succeed(
          "nixos-taskserver org add imperativeOrg",
          "nixos-taskserver user add imperativeOrg bar"
        );
        setupClientsFor "imperativeOrg", "bar";
      });
    }

    sub testSync ($) {
      my $user = $_[0];
      subtest "sync for user $user", sub {
        $client1->succeed(su $user, "task add foo >&2");
        $client1->succeed(su $user, "task sync >&2");
        $client2->fail(su $user, "task list >&2");
        $client2->succeed(su $user, "task sync >&2");
        $client2->succeed(su $user, "task list >&2");
      };
    }

    sub checkClientCert ($) {
      my $user = $_[0];
      my $cmd = "gnutls-cli".
        " --x509cafile=/home/$user/.task/keys/ca.cert".
        " --x509keyfile=/home/$user/.task/keys/private.key".
        " --x509certfile=/home/$user/.task/keys/public.cert".
        " --port=${portStr} server < /dev/null";
      return su $user, $cmd;
    }

    # Explicitly start the VMs so that we don't accidentally start newServer
    $server->start;
    $client1->start;
    $client2->start;

    $server->waitForUnit("taskserver.service");

    $server->succeed(
      "nixos-taskserver user list testOrganisation | grep -qxF alice",
      "nixos-taskserver user list testOrganisation | grep -qxF foo",
      "nixos-taskserver user list anotherOrganisation | grep -qxF bob"
    );

    $server->waitForOpenPort(${portStr});

    $client1->waitForUnit("multi-user.target");
    $client2->waitForUnit("multi-user.target");

    setupClientsFor "testOrganisation", "alice";
    setupClientsFor "testOrganisation", "foo";
    setupClientsFor "anotherOrganisation", "bob";

    testSync $_ for ("alice", "bob", "foo");

    $server->fail("nixos-taskserver user add imperativeOrg bar");
    readdImperativeUser;

    testSync "bar";

    subtest "checking certificate revocation of user bar", sub {
      $client1->succeed(checkClientCert "bar");

      $server->succeed("nixos-taskserver user remove imperativeOrg bar");
      restartServer;

      $client1->fail(checkClientCert "bar");

      $client1->succeed(su "bar", "task add destroy everything >&2");
      $client1->fail(su "bar", "task sync >&2");
    };

    readdImperativeUser;

    subtest "checking certificate revocation of org imperativeOrg", sub {
      $client1->succeed(checkClientCert "bar");

      $server->succeed("nixos-taskserver org remove imperativeOrg");
      restartServer;

      $client1->fail(checkClientCert "bar");

      $client1->succeed(su "bar", "task add destroy even more >&2");
      $client1->fail(su "bar", "task sync >&2");
    };

    readdImperativeUser;

    subtest "check whether declarative config overrides user bar", sub {
      restartServer;
      testSync "bar";
    };

    subtest "check manual configuration", sub {
      $server->succeed('${switchToNewServer} >&2');
      $server->waitForUnit("taskserver.service");
      $server->waitForOpenPort(${portStr});

      $server->succeed(
        "nixos-taskserver org add manualOrg",
        "nixos-taskserver user add manualOrg alice"
      );

      setupClientsFor "manualOrg", "alice", sub {
        my ($client, $org, $user) = @_;
        my $cfgpath = "/home/$user/.task";

        $client->copyFileFromHost("${snakeOil.cacert}", "$cfgpath/ca.cert");
        for my $file ('alice.key', 'alice.cert') {
          $client->copyFileFromHost("${snakeOil}/$file", "$cfgpath/$file");
        }

        for my $file ("$user.key", "$user.cert") {
          $client->copyFileFromHost(
            "${snakeOil}/$file", "$cfgpath/$file"
          );
        }
        $client->copyFileFromHost(
          "${snakeOil.cacert}", "$cfgpath/ca.cert"
        );
        $client->succeed(
          (su "alice", "task config taskd.ca $cfgpath/ca.cert"),
          (su "alice", "task config taskd.key $cfgpath/$user.key"),
          (su $user, "task config taskd.certificate $cfgpath/$user.cert")
        );
      };

      testSync "alice";
    };
  '';
})
