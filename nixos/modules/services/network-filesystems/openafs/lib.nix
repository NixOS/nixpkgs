{ config, lib, ... }:

{

  mkCellServDB =
    cellName: db:
    ''
      >${cellName}
    ''
    + (lib.concatStringsSep "\n" (
      map (dbm: lib.optionalString (dbm.ip != "" && dbm.dnsname != "") "${dbm.ip} #${dbm.dnsname}") db
    ))
    + "\n";

  # CellServDB configuration type
  cellServDBConfig = {
    ip = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "1.2.3.4";
      description = "IP Address of a database server";
    };
    dnsname = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "afs.example.org";
      description = "DNS full-qualified domain name of a database server";
    };
  };

  openafsMod = config.services.openafsClient.packages.module;
  openafsBin = config.services.openafsClient.packages.programs;
  openafsSrv = config.services.openafsServer.package;
}
