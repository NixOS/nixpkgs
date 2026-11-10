{
  lib,
  ...
}:

{
  name = "timekpr";
  meta.maintainers = [ lib.maintainers.atry ];

  containers.machine = {
    services.timekpr.enable = true;
  };

  testScript = ''
    start_all()
    machine.wait_for_file("/etc/timekpr/timekpr.conf")
    machine.wait_for_unit("timekpr.service")
  '';
}
