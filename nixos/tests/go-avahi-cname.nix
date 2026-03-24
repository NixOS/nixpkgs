{
  lib,
  ...
}:
{
  name = "go-avahi-cname";

  meta.maintainers = with lib.maintainers; [ magicquark ];

  nodes.machine = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    # https://github.com/NixOS/nixpkgs/issues/297756
    services.dbus.implementation = "broker";

    services.go-avahi-cname = {
      enable = true;
      mode = "interval-publishing";
      subdomains = [
        "git"
        "printer"
      ];
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("avahi-daemon.service")
    machine.wait_for_unit("go-avahi-cname.service")

    hostname = machine.succeed("hostname").strip()
    machine.succeed(f"avahi-resolve -n git.{hostname}.local")
    machine.succeed(f"avahi-resolve -n printer.{hostname}.local")
  '';
}
