{ lib, pkgs }: {
  mariadbPackages = lib.filterAttrs (n: _: lib.hasPrefix "mariadb" n) (pkgs.callPackage ../../../pkgs/servers/sql/mariadb {
    inherit (pkgs.darwin) cctools;
    inherit (pkgs.darwin.apple_sdk.frameworks) CoreServices;
  });
  mysqlPackages = {
    inherit (pkgs) mysql80;
  };
  mkTestName = pkg: "mariadb_${builtins.replaceStrings ["."] [""] (lib.versions.majorMinor pkg.version)}";
}
