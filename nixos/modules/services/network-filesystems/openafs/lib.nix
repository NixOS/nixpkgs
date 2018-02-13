{ lib, ...}:

let
  inherit (lib) concatStringsSep mkOption types;

in rec {

  mkCellServDB = cellName: db: ''
    >${cellName}
  '' + (concatStringsSep "\n" (map (dbm: if (dbm.ip != "" && dbm.dnsname != "") then dbm.ip + " #" + dbm.dnsname else "")
                                   db));

  # CellServDB configuration type
  cellServDBConfig = {
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
}
