import ./make-test.nix ({ pkgs, lib, ... }:

{
  name = "atd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ bjornfor ];
  };

  machine =
    { config, pkgs, ... }:
    { services.atd.enable = true;
      users.extraUsers.alice = { isNormalUser = true; };
    };

  # "at" has a resolution of 1 minute
  testScript = ''
    startAll;

    $machine->fail("test -f ~root/at-1");
    $machine->fail("test -f ~alice/at-1");

    $machine->succeed("echo 'touch ~root/at-1' | at now+1min");
    $machine->succeed("su - alice -c \"echo 'touch at-1' | at now+1min\"");

    $machine->succeed("sleep 1.5m");

    $machine->succeed("test -f ~root/at-1");
    $machine->succeed("test -f ~alice/at-1");
  '';
})
