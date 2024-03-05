{ config, lib, ...}:

let
  inherit (lib) concatStringsSep mkOption types optionalString;

in {

  mkCellServDB = cellName: db: ''
    >${cellName}
  '' + (concatStringsSep "\n" (map (dbm: optionalString (dbm.ip != "" && dbm.dnsname != "") "${dbm.ip} #${dbm.dnsname}")
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
