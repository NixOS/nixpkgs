{ config, lib, ... }:

let
  inherit (lib)
    concatStringsSep
    concatMapAttrsStringSep
    mkOption
    types
    optionalString
    ;
  cellServDBMemberType = types.submodule {
    options = {
      ip = mkOption {
        type = types.str;
        default = "";
        example = "1.2.3.4";
        description = "IP Address of a database server";
      };
      dnsname = mkOption {
        type = types.str;
        default = "";
        example = "afs.example.org";
        description = "DNS full-qualified domain name of a database server";
      };
    };
  };
  cellServDBCellType = types.listOf cellServDBMemberType;
in
{

  mkCellServDB = concatMapAttrsStringSep "" (
    cellName: db:
    ''
      >${cellName}
    ''
    + (concatStringsSep "\n" (
      map (dbm: optionalString (dbm.ip != "" && dbm.dnsname != "") "${dbm.ip} #${dbm.dnsname}") db
    ))
    + "\n"
  );

  # CellServDB configuration type
  cellServDBType =
    thisCell:
    types.coercedTo (types.listOf types.anything) (m: { "${thisCell}" = m; }) (
      types.attrsOf cellServDBCellType
    );

  openafsMod = config.services.openafsClient.packages.module;
  openafsBin = config.services.openafsClient.packages.programs;
  openafsSrv = config.services.openafsServer.package;
}
