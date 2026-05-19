{ lib, ... }:
let
  pkgs.hello = {
    type = "derivation";
    pname = "hello";
  };
in
{
  options = {
    package = lib.mkPackageOption pkgs "hello" { };

    namedPackage = lib.mkPackageOption pkgs "Hello" {
      default = [ "hello" ];
    };

    namedPackageSingletonDefault = lib.mkPackageOption pkgs "Hello" {
      default = "hello";
    };

    pathPackage = lib.mkPackageOption pkgs [ "hello" ] { };

    packageWithExample = lib.mkPackageOption pkgs "hello" {
      example = "pkgs.hello.override { stdenv = pkgs.clangStdenv; }";
    };

    packageWithPathExample = lib.mkPackageOption pkgs "hello" {
      example = [ "hello" ];
    };

    packageWithExtraDescription = lib.mkPackageOption pkgs "hello" {
      extraDescription = "Example extra description.";
    };

    undefinedPackage = lib.mkPackageOption pkgs "hello" {
      default = null;
    };

    nullablePackage = lib.mkPackageOption pkgs "hello" {
      nullable = true;
      default = null;
    };

    nullablePackageWithDefault = lib.mkPackageOption pkgs "hello" {
      nullable = true;
    };

    packageWithPkgsText = lib.mkPackageOption pkgs "hello" {
      pkgsText = "myPkgs";
    };

    packageFromOtherSet =
      let
        myPkgs = {
          hello = pkgs.hello // {
            pname = "hello-other";
          };
        };
      in
      lib.mkPackageOption myPkgs "hello" { };

    packageInvalidIdentifier =
      let
        myPkgs."123"."with\"quote" = { inherit (pkgs) hello; };
      in
      lib.mkPackageOption myPkgs [ "123" "with\"quote" "hello" ] { };

    packageInvalidIdentifierExample = lib.mkPackageOption pkgs "hello" {
      example = [
        "123"
        "with\"quote"
        "hello"
      ];
    };
  };
}
