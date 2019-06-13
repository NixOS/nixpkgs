import ./make-test.nix ({ pkgs, ...} : {
  name = "memcached";

  nodes = {
    machine =
      { ... }:
      {
        imports = [ ../modules/profiles/minimal.nix ];
        services.memcached.enable = true;
      };
  };

  testScript = let
    testScript = pkgs.writeScript "testScript.py" ''
      #!${pkgs.python3.withPackages (p: [p.memcached])}/bin/python

      import memcache
      c = memcache.Client(['localhost:11211'])
      c.set('key', 'value')
      assert 'value' == c.get('key')
    '';
  in ''
    startAll;
    $machine->waitForUnit("memcached.service");
    $machine->waitForOpenPort("11211");
    $machine->succeed("${testScript}");
  '';
})
