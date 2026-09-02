let
  features = [
    {
      description = "the `nixVersion` builtin";
      condition = builtins ? nixVersion;
    }
    {
      description = "`builtins.nixVersion` reports at least 2.18";
      # Note: This can never be updated, because Lix will always
      # report 2.18 despite supporting newer features. (Hence the need
      # for a feature-based minimum.)
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
