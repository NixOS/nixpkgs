{ pkgs, ... }:
{
  name = "memcached";

  nodes.machine = {
    imports = [ ../modules/profiles/minimal.nix ];
    services.memcached.enable = true;
  };

  testScript =
    let
      testScript =
        pkgs.writers.writePython3 "test_memcache"
          {
            libraries = [ pkgs.python3Packages.python-memcached ];
          }
          ''
            import memcache
            c = memcache.Client(['localhost:11211'])
            c.set('key', 'value')
            assert 'value' == c.get('key')
          '';
    in
    ''
      machine.start()
      machine.wait_for_unit("memcached.service")
      machine.wait_for_open_port(11211)
      machine.succeed("${testScript}")
    '';
}
