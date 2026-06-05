let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
in
{
  vars = {
    defaultGeneratorBackend = "example";
    generatorBackends.example = {
      get = noop;
      set = noop;
      exists = noop;
      deploy = noop;
      fixup = noop; # This one's optional, but I wanted to make sure that works
    };
  };
}
