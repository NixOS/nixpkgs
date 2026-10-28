let
  lib = import ../../..;

  evaluation = lib.evalModules {
    modules = [
      { }
      (args: { })
      ./a.nix
      ./b.nix
    ];
  };

  actual = evaluation.graph;

  expected = [
    {
      key = ":anon-1";
      file = "<unknown-file>";
      imports = [ ];
      disabled = false;
    }
    {
      key = ":anon-2";
      file = "<unknown-file>";
      imports = [ ];
      disabled = false;
    }
    {
      key = toString ./a.nix;
      file = toString ./a.nix;
      imports = [
        {
          key = "${toString ./a.nix}:anon-1";
          file = toString ./a.nix;
          imports = [
            {
              key = "${toString ./a.nix}:anon-1:anon-1";
              file = toString ./a.nix;
              imports = [ ];
              disabled = false;
            }
          ];
          disabled = false;
        }
      ];
      disabled = false;
    }
    {
      key = toString ./b.nix;
      file = toString ./b.nix;
      imports = [
        {
          key = "explicit-key";
          file = toString ./b.nix;
          imports = [ ];
          disabled = false;
        }
      ];
      disabled = true;
    }
  ];
in
assert actual == expected;
null
