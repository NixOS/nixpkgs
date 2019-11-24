import ./make-test.nix ({ lib, ... }:

{
  name = "mailcatcher";
  meta.maintainers = [ lib.maintainers.aanderse ];

  machine =
    { pkgs, ... }:
    {
      services.mailcatcher.enable = true;

      services.ssmtp.enable = true;
      services.ssmtp.hostName = "localhost:1025";

      environment.systemPackages = [ pkgs.mailutils ];
    };

  testScript = ''
    startAll;

    $machine->waitForUnit('mailcatcher.service');
    $machine->waitForOpenPort('1025');
    $machine->succeed('echo "this is the body of the email" | mail -s "subject" root@example.org');
    $machine->succeed('curl http://localhost:1080/messages/1.source') =~ /this is the body of the email/ or die;
  '';
})
