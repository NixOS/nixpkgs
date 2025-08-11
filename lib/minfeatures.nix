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
in
# Exposes the missing features for evaluating Nixpkgs
builtins.map ({ description, ... }: description) (
  builtins.filter ({ condition, ... }: !condition) features
)
