{ lib, pkgs, ... }:
{
  name = "part-db";
  meta.maintainers = with lib.maintainers; [ oddlama ];

  nodes = {
    machine = {
      services.part-db.enable = true;
    };
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("postgresql.service")
    machine.wait_for_unit("part-db-migrate.service")
    machine.wait_for_unit("phpfpm-part-db.service")
    machine.wait_for_unit("nginx.service")

    machine.succeed("test -d /var/lib/part-db/public/media")
    machine.succeed("test -d /var/lib/part-db/uploads")
    machine.succeed("test -d /var/lib/part-db/share")
    machine.succeed("test $(readlink ${pkgs.part-db}/public/media) = /var/lib/part-db/public/media/")
    machine.succeed("test $(readlink ${pkgs.part-db}/uploads) = /var/lib/part-db/uploads/")

    machine.wait_for_open_port(80)

    machine.succeed("curl -L --fail http://localhost | grep 'Part-DB'", timeout=10)
    machine.succeed("echo static > /var/lib/part-db/public/media/static.txt")
    machine.succeed("curl -I --fail http://localhost/media/static.txt | grep 'Content-Security-Policy'")
    machine.succeed("curl -I --fail http://localhost/media/static.txt | grep 'X-Content-Type-Options: nosniff'")
    machine.succeed("echo '<?php echo 1; ?>' > /var/lib/part-db/public/media/shell.phar")
    machine.succeed("curl -I http://localhost/media/shell.phar | grep 'HTTP/1.1 403 Forbidden'")
  '';
}
