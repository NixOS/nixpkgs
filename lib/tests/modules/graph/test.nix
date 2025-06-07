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
in
{
  actual = evaluation.graph;

  expected = [
    {
      key = ":anon-1";
      imports = [ ];
      disabled = false;
    }
    {
      key = ":anon-2";
      imports = [ ];
      disabled = false;
    }
    {
      key = toString ./a.nix;
      imports = [
        {
          key = "${toString ./a.nix}:anon-1";
          imports = [
            {
              key = "${toString ./a.nix}:anon-1:anon-1";
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
      imports = [ ];
      disabled = true;
    }
  ];
}
