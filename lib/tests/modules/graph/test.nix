let
  lib = import ../../..;

  evaluation = lib.evalModules {
    # specialArgs.modulesPath = ./.;
    modules = [
      { }
      (args: { })
      ./a.nix
      ./b.nix
    ];
  };

  actual = evaluation.graph;

  expected = {
    modules = [
      {
        key = ":anon-1";
        modules = [ ];
        disabled = false;
      }
      {
        key = ":anon-2";
        modules = [ ];
        disabled = false;
      }
      {
        key = toString ./a.nix;
        modules = [
          {
            key = "${toString ./a.nix}:anon-1";
            modules = [ ];
            disabled = false;
          }
        ];
        disabled = false;
      }
      {
        key = toString ./b.nix;
        modules = [ ];
        disabled = true;
      }
    ];
  };
in
if actual == expected then "ok" else { inherit actual expected; }
