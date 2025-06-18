{
  config,
  lib,
  pkgs,
  ...
}:

# openafsMod, openafsBin, mkCellServDB
with import ./lib.nix { inherit config lib pkgs; };

let
  inherit (lib)
    getBin
    literalExpression
    mkOption
    mkIf
    optionalString
    singleton
    types
    ;

  cfg = config.services.openafsClient;

  cellServDB = pkgs.fetchurl {
    url = "http://dl.central.org/dl/cellservdb/CellServDB.2018-05-14";
    sha256 = "1wmjn6mmyy2r8p10nlbdzs4nrqxy8a9pjyrdciy5nmppg4053rk2";
  };

  clientServDB = pkgs.writeText "client-cellServDB-${cfg.cellName}" (
    mkCellServDB cfg.cellName cfg.cellServDB
  );

  afsConfig = pkgs.runCommand "afsconfig" { preferLocalBuild = true; } ''
    mkdir -p $out
    echo ${cfg.cellName} > $out/ThisCell
    cat ${cellServDB} ${clientServDB} > $out/CellServDB
    echo "${cfg.mountPoint}:${cfg.cache.directory}:${toString cfg.cache.blocks}" > $out/cacheinfo
  '';

in
{
  ###### interface

  options = {

    services.openafsClient = {

      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Whether to enable the OpenAFS client.";
      };

      afsdb = mkOption {
        default = true;
        type = types.bool;
        description = "Resolve cells via AFSDB DNS records.";
      };

      cellName = mkOption {
        default = "";
        type = types.str;
        description = "Cell name.";
        example = "grand.central.org";
      };

      cellServDB = mkOption {
        default = [ ];
        type =
          with types;
          listOf (submodule {
            options = cellServDBConfig;
          });
        description = ''
          This cell's database server records, added to the global
          CellServDB. See {manpage}`CellServDB(5)` man page for syntax. Ignored when
          `afsdb` is set to `true`.
        '';
        example = [
          {
            ip = "1.2.3.4";
            dnsname = "first.afsdb.server.dns.fqdn.org";
          }
          {
            ip = "2.3.4.5";
            dnsname = "second.afsdb.server.dns.fqdn.org";
          }
        ];
      };

      cache = {
        blocks = mkOption {
          default = 100000;
          type = types.int;
          description = "Cache size in 1KB blocks.";
        };

        chunksize = mkOption {
          default = 0;
          type = types.ints.between 0 30;
          description = ''
            Size of each cache chunk given in powers of
            2. `0` resets the chunk size to its default
            values (13 (8 KB) for memcache, 18-20 (256 KB to 1 MB) for
            diskcache). Maximum value is 30. Important performance
            parameter. Set to higher values when dealing with large files.
          '';
        };

        directory = mkOption {
          default = "/var/cache/openafs";
          type = types.str;
          description = "Cache directory.";
        };

        diskless = mkOption {
          default = false;
          type = types.bool;
          description = ''
            Use in-memory cache for diskless machines. Has no real
            performance benefit anymore.
          '';
        };
      };

      crypt = mkOption {
        default = true;
        type = types.bool;
        description = "Whether to enable (weak) protocol encryption.";
      };

      daemons = mkOption {
        default = 2;
        type = types.int;
        description = ''
          Number of daemons to serve user requests. Numbers higher than 6
          usually do no increase performance. Default is sufficient for up
          to five concurrent users.
        '';
      };

      fakestat = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Return fake data on stat() calls. If `true`,
          always do so. If `false`, only do so for
          cross-cell mounts (as these are potentially expensive).
        '';
      };

      inumcalc = mkOption {
        default = "compat";
        type = types.strMatching "compat|md5";
        description = ''
          Inode calculation method. `compat` is
          computationally less expensive, but `md5` greatly
          reduces the likelihood of inode collisions in larger scenarios
          involving multiple cells mounted into one AFS space.
        '';
      };

      mountPoint = mkOption {
        default = "/afs";
        type = types.str;
        description = ''
          Mountpoint of the AFS file tree, conventionally
          `/afs`. When set to a different value, only
          cross-cells that use the same value can be accessed.
        '';
      };

      packages = {
        module = mkOption {
          default = config.boot.kernelPackages.openafs;
          defaultText = literalExpression "config.boot.kernelPackages.openafs";
          type = types.package;
          description = "OpenAFS kernel module package. MUST match the userland package!";
        };
        programs = mkOption {
          default = getBin pkgs.openafs;
          defaultText = literalExpression "getBin pkgs.openafs";
          type = types.package;
          description = "OpenAFS programs package. MUST match the kernel module package!";
        };
      };

      sparse = mkOption {
        default = true;
        type = types.bool;
        description = "Minimal cell list in /afs.";
      };

      startDisconnected = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Start up in disconnected mode.  You need to execute
          `fs disco online` (as root) to switch to
          connected mode. Useful for roaming devices.
        '';
      };

    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    assertions = [
      {
        assertion = cfg.afsdb || cfg.cellServDB != [ ];
        message = "You should specify all cell-local database servers in config.services.openafsClient.cellServDB or set config.services.openafsClient.afsdb.";
      }
      {
        assertion = cfg.cellName != "";
        message = "You must specify the local cell name in config.services.openafsClient.cellName.";
      }
    ];

    environment.systemPackages = [ openafsBin ];

    environment.etc = {
      clientCellServDB = {
        source = pkgs.runCommand "CellServDB" { preferLocalBuild = true; } ''
          cat ${cellServDB} ${clientServDB} > $out
        '';
        target = "openafs/CellServDB";
        mode = "0644";
      };
      clientCell = {
        text = ''
          ${cfg.cellName}
        '';
        target = "openafs/ThisCell";
        mode = "0644";
      };
    };

    systemd.services.afsd = {
      description = "AFS client";
      wantedBy = [ "multi-user.target" ];
      wants = lib.optional (!cfg.startDisconnected) "network-online.target";
      after = singleton (if cfg.startDisconnected then "network.target" else "network-online.target");
      serviceConfig = {
        RemainAfterExit = true;
      };
      restartIfChanged = false;

      preStart = ''
        mkdir -p -m 0755 ${cfg.mountPoint}
        mkdir -m 0700 -p ${cfg.cache.directory}
        ${pkgs.kmod}/bin/insmod ${openafsMod}/lib/modules/*/extra/openafs/libafs.ko.xz
        ${openafsBin}/sbin/afsd \
          -mountdir ${cfg.mountPoint} \
          -confdir ${afsConfig} \
          ${optionalString (!cfg.cache.diskless) "-cachedir ${cfg.cache.directory}"} \
          -blocks ${toString cfg.cache.blocks} \
          -chunksize ${toString cfg.cache.chunksize} \
          ${optionalString cfg.cache.diskless "-memcache"} \
          -inumcalc ${cfg.inumcalc} \
          ${if cfg.fakestat then "-fakestat-all" else "-fakestat"} \
          ${if cfg.sparse then "-dynroot-sparse" else "-dynroot"} \
          ${optionalString cfg.afsdb "-afsdb"}
        ${openafsBin}/bin/fs setcrypt ${if cfg.crypt then "on" else "off"}
        ${optionalString cfg.startDisconnected "${openafsBin}/bin/fs discon offline"}
      '';

      # Doing this in preStop, because after these commands AFS is basically
      # stopped, so systemd has nothing to do, just noticing it.  If done in
      # postStop, then we get a hang + kernel oops, because AFS can't be
      # stopped simply by sending signals to processes.
      preStop = ''
        ${pkgs.util-linux}/bin/umount ${cfg.mountPoint}
        ${openafsBin}/sbin/afsd -shutdown
        ${pkgs.kmod}/sbin/rmmod libafs
      '';
    };
  };
}
