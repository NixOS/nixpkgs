{ config, pkgs, lib, ... }:

let
  inherit (lib) mkOption mkIf;

  cfg = config.services.openafsClient;

  cellServDB = pkgs.fetchurl {
    url = http://dl.central.org/dl/cellservdb/CellServDB.2017-03-14;
    sha256 = "1197z6c5xrijgf66rhaymnm5cvyg2yiy1i20y4ah4mrzmjx0m7sc";
  };

  afsConfig = pkgs.runCommand "afsconfig" {} ''
    mkdir -p $out
    echo ${cfg.cellName} > $out/ThisCell
    cp ${cellServDB} $out/CellServDB
    echo "/afs:${cfg.cacheDirectory}:${cfg.cacheSize}" > $out/cacheinfo
  '';

  openafsPkgs = config.boot.kernelPackages.openafsClient;
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

      crypt = mkOption {
        default = false;
        description = "Whether to enable (weak) protocol encryption.";
      };

      sparse = mkOption {
        default = false;
        description = "Minimal cell list in /afs.";
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ openafsPkgs ];

    environment.etc = [
      { source = afsConfig;
        target = "openafs";
      }
    ];

    systemd.services.afsd = {
      description = "AFS client";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = { RemainAfterExit = true; };

      preStart = ''
        mkdir -p -m 0755 /afs
        mkdir -m 0700 -p ${cfg.cacheDirectory}
        ${pkgs.kmod}/bin/insmod ${openafsPkgs}/lib/openafs/libafs-*.ko || true
        ${openafsPkgs}/sbin/afsd -confdir ${afsConfig} -cachedir ${cfg.cacheDirectory} ${if cfg.sparse then "-dynroot-sparse" else "-dynroot"} -fakestat -afsdb
        ${openafsPkgs}/bin/fs setcrypt ${if cfg.crypt then "on" else "off"}
      '';

      # Doing this in preStop, because after these commands AFS is basically
      # stopped, so systemd has nothing to do, just noticing it.  If done in
      # postStop, then we get a hang + kernel oops, because AFS can't be
      # stopped simply by sending signals to processes.
      preStop = ''
        ${pkgs.utillinux}/bin/umount /afs
        ${openafsPkgs}/sbin/afsd -shutdown
      '';
    };
  };
}
