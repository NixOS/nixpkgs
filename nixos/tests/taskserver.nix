import ./make-test.nix {
  name = "taskserver";

  nodes = {
    server = {
      networking.firewall.enable = false;
      services.taskserver.enable = true;
      services.taskserver.server.host = "::";
      services.taskserver.server.fqdn = "server";
      services.taskserver.organisations = {
        testOrganisation.users = [ "alice" "foo" ];
        anotherOrganisation.users = [ "bob" ];
      };
    };

    client1 = { pkgs, ... }: {
      networking.firewall.enable = false;
      environment.systemPackages = [ pkgs.taskwarrior ];
      users.users.alice.isNormalUser = true;
      users.users.bob.isNormalUser = true;
      users.users.foo.isNormalUser = true;
    };

    client2 = { pkgs, ... }: {
      networking.firewall.enable = false;
      environment.systemPackages = [ pkgs.taskwarrior ];
      users.users.alice.isNormalUser = true;
      users.users.bob.isNormalUser = true;
      users.users.foo.isNormalUser = true;
    };
  };

  testScript = { nodes, ... }: let
    cfg = nodes.server.config.services.taskserver;
    portStr = toString cfg.server.port;
  in ''
    sub su ($$) {
      my ($user, $cmd) = @_;
      my $esc = $cmd =~ s/'/'\\${"'"}'/gr;
      return "su - $user -c '$esc'";
    }

    sub setupClientsFor ($$) {
      my ($org, $user) = @_;

      for my $client ($client1, $client2) {
        $client->nest("initialize client for user $user", sub {
          $client->succeed(
            su $user, "task rc.confirmation=no config confirmation no"
          );

          my $exportinfo = $server->succeed(
            "nixos-taskdctl export-user $org $user"
          );

          $exportinfo =~ s/'/'\\'''/g;

          $client->succeed(su $user, "eval '$exportinfo' >&2");
          $client->succeed(su $user,
            "task config taskd.server server:${portStr} >&2"
          );

          $client->succeed(su $user, "task sync init >&2");
        });
      }
    }

    startAll;

    $server->waitForUnit("taskserver.service");

    $server->succeed(
      "nixos-taskdctl list-users testOrganisation | grep -qxF alice",
      "nixos-taskdctl list-users testOrganisation | grep -qxF foo",
      "nixos-taskdctl list-users anotherOrganisation | grep -qxF bob"
    );

    $server->waitForOpenPort(${portStr});

    $client1->waitForUnit("multi-user.target");
    $client2->waitForUnit("multi-user.target");

    setupClientsFor "testOrganisation", "alice";
    setupClientsFor "testOrganisation", "foo";
    setupClientsFor "anotherOrganisation", "bob";

    for ("alice", "bob", "foo") {
      subtest "sync for $_", sub {
        $client1->succeed(su $_, "task add foo >&2");
        $client1->succeed(su $_, "task sync >&2");
        $client2->fail(su $_, "task list >&2");
        $client2->succeed(su $_, "task sync >&2");
        $client2->succeed(su $_, "task list >&2");
      };
    }
  '';
}
