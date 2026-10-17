{ pkgs, ... }:
{
  name = "harmonia-gc";
  meta.maintainers = [ pkgs.lib.maintainers.mic92 ];

  nodes.machine =
    { pkgs, ... }:
    {
      services.harmonia.gc = {
        enable = true;
        automatic = true;
        keepRecent = "1h";
      };
      nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)
      virtualisation.writableStore = true;
      environment.systemPackages = [
        pkgs.hello
        pkgs.sqlite
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("systemctl is-active harmonia-gc.timer")

    db = "/nix/var/nix/db/db.sqlite"

    def gc() -> None:
        machine.succeed("systemctl start harmonia-gc.service")

    # load-db at boot sets registrationTime=now; stop keepRecent from pinning everything.
    machine.succeed(f"sqlite3 {db} 'UPDATE ValidPaths SET registrationTime = 1'")

    machine.succeed("echo dead > /tmp/dead", "echo rooted > /tmp/rooted")
    dead = machine.succeed("nix-store --add /tmp/dead").strip()
    rooted = machine.succeed("nix-store --add /tmp/rooted").strip()
    machine.succeed(f"ln -s {rooted} /nix/var/nix/gcroots/rooted")
    machine.succeed(
        f"sqlite3 {db} \"UPDATE ValidPaths SET registrationTime = 1 WHERE path IN ('{dead}', '{rooted}')\""
    )

    gc()
    machine.fail(f"test -e {dead}")
    machine.succeed(f"test -e {rooted}")
    # system profile is a root
    machine.succeed("hello --version")

    # keepRecent pins freshly registered paths
    machine.succeed("echo recent > /tmp/recent")
    recent = machine.succeed("nix-store --add /tmp/recent").strip()
    gc()
    machine.succeed(f"test -e {recent}")
  '';
}
