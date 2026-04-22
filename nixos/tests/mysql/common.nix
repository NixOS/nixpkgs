{ lib, pkgs }:
{
  mariadbPackages = lib.filterAttrs (n: _: lib.hasPrefix "mariadb" n) (
    import ../../../pkgs/servers/sql/mariadb pkgs
  );
  mysqlPackages = {
    inherit (pkgs) mysql84;
  };
  perconaPackages = {
    inherit (pkgs) percona-server_8_4;
  };
  mkTestName =
    pkg: "mariadb_${builtins.replaceStrings [ "." ] [ "" ] (lib.versions.majorMinor pkg.version)}";
}
