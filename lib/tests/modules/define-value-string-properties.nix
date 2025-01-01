{ lib, ... }: {

  imports = [{
    value = lib.mkDefault "def";
  }];

  value = lib.mkMerge [
    (lib.mkIf false "nope")
    "yes"
  ];

}
