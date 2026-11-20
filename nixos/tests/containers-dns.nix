{ ... }:
{
  name = "containers-dns";
  meta.maintainers = [ ];
  containers.machine = {
    security.wrappers = { };
    networking.resolvconf.enable = true;
  };
  testScript = ''
    machine.wait_for_unit("resolvconf.service")
  '';
}
