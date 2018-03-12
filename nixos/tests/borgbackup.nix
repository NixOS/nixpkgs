import ./make-test.nix ({ pkgs, ...}: {
  name = "borgbackup";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ mic92 ];
  };

  nodes = {
    machine = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.borgbackup ];
    };
  };

  testScript = ''
    my $borg = "BORG_PASSPHRASE=supersecret borg";
    $machine->succeed("$borg init --encryption=repokey /tmp/backup");
    $machine->succeed("mkdir /tmp/data/ && echo 'data' >/tmp/data/file");
    $machine->succeed("$borg create --stats /tmp/backup::test /tmp/data");
    $machine->succeed("$borg extract /tmp/backup::test");
    $machine->succeed('c=$(cat data/file) && echo "c = $c" >&2 && [[ "$c" == "data" ]]');
  '';
})
