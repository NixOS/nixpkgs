let
  features = [
    {
      description = "the `nixVersion` builtin";
      condition = builtins ? nixVersion;
    }
    {
      description = "`builtins.nixVersion` reports at least 2.18";
      condition = builtins ? nixVersion && builtins.compareVersions "2.18" builtins.nixVersion != 1;
    }
  ];

  evaluated = builtins.partition ({ condition, ... }: condition) features;
in
{
  all = features;
  supported = evaluated.right;
  missing = evaluated.wrong;
}
