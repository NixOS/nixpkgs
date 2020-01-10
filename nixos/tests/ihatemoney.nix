{ system ? builtins.currentSystem
, config ? {}
, pkgs ? import ../.. { inherit system config; }
}:

let
  inherit (import ../lib/testing.nix { inherit system pkgs; }) makeTest;
in
map (
  backend: makeTest {
    name = "ihatemoney-${backend}";
    machine = { lib, ... }: {
      services.ihatemoney = {
        enable = true;
        enablePublicProjectCreation = true;
        inherit backend;
        uwsgiConfig = {
          http = ":8000";
        };
      };
      boot.cleanTmpDir = true;
      # ihatemoney needs a local smtp server otherwise project creation just crashes
      services.opensmtpd = {
        enable = true;
        serverConfiguration = ''
          listen on lo
          action foo relay
          match from any for any action foo
        '';
      };
    };
    testScript = ''
      $machine->waitForOpenPort(8000);
      $machine->waitForUnit("uwsgi.service");
      my $return = $machine->succeed("curl -X POST http://localhost:8000/api/projects -d 'name=yay&id=yay&password=yay&contact_email=yay\@example.com'");
      die "wrong project id $return" unless "\"yay\"\n" eq $return;
      my $timestamp = $machine->succeed("stat --printf %Y /var/lib/ihatemoney/secret_key");
      my $owner = $machine->succeed("stat --printf %U:%G /var/lib/ihatemoney/secret_key");
      die "wrong ownership for the secret key: $owner, is uwsgi running as the right user ?" unless $owner eq "ihatemoney:ihatemoney";
      $machine->shutdown();
      $machine->start();
      $machine->waitForOpenPort(8000);
      $machine->waitForUnit("uwsgi.service");
      # check that the database is really persistent
      print $machine->succeed("curl --basic -u yay:yay http://localhost:8000/api/projects/yay");
      # check that the secret key is really persistent
      my $timestamp2 = $machine->succeed("stat --printf %Y /var/lib/ihatemoney/secret_key");
      die unless $timestamp eq $timestamp2;
      $machine->succeed("curl http://localhost:8000 | grep ihatemoney");
    '';
  }
) [ "sqlite" "postgresql" ]
