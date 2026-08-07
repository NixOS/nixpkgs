{ ... }:
{
  # python-http-server is a test-only service with no package `services` attr,
  # so the pure base is imported by path rather than via `pkgs.<name>.services`.
  _class = "service";
  imports = [ ../../../../../../tests/modular-service-etc/python-http-server.nix ];
}
