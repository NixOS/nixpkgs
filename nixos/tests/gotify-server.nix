import ./make-test.nix ({ pkgs, lib, ...} : {
  name = "gotify-server";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ ma27 ];
  };

  machine = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.jq ];

    services.gotify = {
      enable = true;
      port = 3000;
    };
  };

  testScript = ''
    startAll;

    $machine->waitForUnit("gotify-server");
    $machine->waitForOpenPort(3000);

    my $token = $machine->succeed(
      "curl --fail -sS -X POST localhost:3000/application -F name=nixos " .
      '-H "Authorization: Basic $(echo -ne "admin:admin" | base64 --wrap 0)" ' .
      '| jq .token | xargs echo -n'
    );

    my $usertoken = $machine->succeed(
      "curl --fail -sS -X POST localhost:3000/client -F name=nixos " .
      '-H "Authorization: Basic $(echo -ne "admin:admin" | base64 --wrap 0)" ' .
      '| jq .token | xargs echo -n'
    );

    $machine->succeed(
      "curl --fail -sS -X POST 'localhost:3000/message?token=$token' -H 'Accept: application/json' " .
      '-F title=Gotify -F message=Works'
    );

    my $title = $machine->succeed(
      "curl --fail -sS 'localhost:3000/message?since=0&token=$usertoken' | jq '.messages|.[0]|.title' | xargs echo -n"
    );

    $title eq "Gotify" or die "Wrong title ($title), expected 'Gotify'!";
  '';
})
