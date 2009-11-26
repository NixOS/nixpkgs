{ config, pkgs, ... }:

let
  inherit (pkgs.lib) mkOption mkIf;

  cfg = config.services.openafsClient;

  cellServDB = pkgs.fetchurl {
    url = http://dl.central.org/dl/cellservdb/CellServDB.2009-06-29;
    sha256 = "be566f850e88130333ab8bc3462872ad90c9482e025c60a92f728b5bac1b4fa9";
  };

  afsConfig = pkgs.runCommand "afsconfig" {} ''
    ensureDir $out
    echo ${cfg.cellName} > $out/ThisCell
    cp ${cellServDB} $out/CellServDB
    echo "/afs:${cfg.cacheDirectory}:${cfg.cacheSize}" > $out/cacheinfo
  '';
in
{
  ###### interface

  options = {

    services.openafsClient = {

      enable = mkOption {
        default = false;
        description = "Whether to enable the OpenAFS client.";
      };

      cellName = mkOption {
        default = "grand.central.org";
        description = "Cell name.";
      };

      cacheSize = mkOption {
        default = "100000";
        description = "Cache size.";
      };

      cacheDirectory = mkOption {
        default = "/var/cache/openafs";
        description = "Cache directory.";
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [pkgs.openafsClient];

    environment.etc = [
      { source = afsConfig;
        target = "openafs";
      }
    ];

    jobs.openafsClient =
      { name = "afsd";

        description = "AFS client";

        startOn = "started network-interfaces";
        stopOn = "stopping network-interfaces";

	preStart = ''
	  mkdir -m 0755 /afs || true
	  mkdir -m 0755 -p ${cfg.cacheDirectory} || true
          ${pkgs.module_init_tools}/sbin/insmod ${pkgs.openafsClient}/lib/openafs/libafs-*.ko || true
          ${pkgs.openafsClient}/sbin/afsd -confdir ${afsConfig} -cachedir ${cfg.cacheDirectory} -dynroot -fakestat
	'';

	postStop = ''
	  umount /afs
          ${pkgs.openafsClient}/sbin/afsd -shutdown
	  rmmod libafs
	'';

      };

  };

}
