import ./make-test.nix ({ pkgs, ...} : {
  name = "openarena";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ tomfitzhenry ];
  };

  machine =
    { pkgs, ... }:

    { imports = [];
      environment.systemPackages = with pkgs; [
        socat
      ];
      services.openarena = {
        enable = true;
        extraFlags = [
          "+set dedicated 2"
          "+set sv_hostname 'My NixOS server'"
          "+map oa_dm1"
        ];
      };
    };

  testScript =
    ''
      $machine->waitForUnit("openarena.service");
      $machine->waitUntilSucceeds("ss --numeric --udp --listening | grep -q 27960");

      # The log line containing 'resolve address' is last and only message that occurs after
      # the server starts accepting clients.
      $machine->waitUntilSucceeds("journalctl -u openarena.service | grep 'resolve address: dpmaster.deathmask.net'");

      # Check it's possible to join the server.
      $machine->succeed("echo -n -e '\\xff\\xff\\xff\\xffgetchallenge' | socat - UDP4-DATAGRAM:127.0.0.1:27960 | grep -q challengeResponse");
    '';
})
