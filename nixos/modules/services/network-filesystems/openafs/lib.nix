{ config, lib, ...}:

let
  inherit (lib) concatStringsSep mkOption types;

in {

  mkCellServDB = cellName: db: ''
    >${cellName}
  '' + (concatStringsSep "\n" (map (dbm: if (dbm.ip != "" && dbm.dnsname != "") then dbm.ip + " #" + dbm.dnsname else "")
                                   db))
     + "\n";

  # CellServDB configuration type
  cellServDBConfig = {
    ip = mkOption {
      type = types.str;
      default = "";
      example = "1.2.3.4";
      description = lib.mdDoc "IP Address of a database server";
    };
    dnsname = mkOption {
      type = types.str;
      default = "";
      example = "afs.example.org";
      description = lib.mdDoc "DNS full-qualified domain name of a database server";
    };
  };

  openafsMod = config.services.openafsClient.packages.module;
  openafsBin = config.services.openafsClient.packages.programs;
  openafsSrv = config.services.openafsServer.package;
}
