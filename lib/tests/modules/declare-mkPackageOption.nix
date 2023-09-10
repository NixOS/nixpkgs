{ lib, ... }: let
  pkgs.hello = {
    type = "derivation";
    pname = "hello";
  };
in {
  options = {
    package = lib.mkPackageOption pkgs "hello" { };

    undefinedPackage = lib.mkPackageOption pkgs "hello" {
      default = null;
    };

    nullablePackage = lib.mkPackageOption pkgs "hello" {
      nullable = true;
      default = null;
    };
  };
}
