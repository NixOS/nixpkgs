{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.below;
  cfgContents = concatStringsSep "\n" (
    mapAttrsToList (n: v: ''${n} = "${v}"'') (filterAttrs (_k: v: v != null) {
      log_dir = cfg.dirs.log;
      store_dir = cfg.dirs.store;
      cgroup_filter_out = cfg.cgroupFilterOut;
    })
  );

  mkDisableOption = n: mkOption {
    type = types.bool;
    default = true;
    description = mdDoc "Whether to enable ${n}.";
  };
  optionalType = ty: x: mkOption (x // {
    description = mdDoc x.description;
    type = (types.nullOr ty);
    default = null;
  });
  optionalPath = optionalType types.path;
  optionalStr = optionalType types.str;
  optionalInt = optionalType types.int;
in {
  options = {
    services.below = {
      enable = mkEnableOption (mdDoc "'below' resource monitor");

      cgroupFilterOut = optionalStr {
        description = "A regexp matching the full paths of cgroups whose data shouldn't be collected";
        example = "user.slice.*";
      };
      collect = {
        diskStats = mkDisableOption "dist_stat collection";
        ioStats   = mkEnableOption (mdDoc "io.stat collection for cgroups");
        exitStats = mkDisableOption "eBPF-based exitstats";
      };
      compression.enable = mkEnableOption (mdDoc "data compression");
      retention = {
        size = optionalInt {
          description = ''
            Size limit for below's data, in bytes. Data is deleted oldest-first, in 24h 'shards'.

            ::: {.note}
            The size limit may be exceeded by at most the size of the active shard, as:
            - the active shard cannot be deleted;
            - the size limit is only enforced when a new shard is created.
            :::
          '';
        };
        time = optionalInt {
          description = ''
            Retention time, in seconds.

            ::: {.note}
            As data is stored in 24 hour shards which are discarded as a whole,
            only data expired by 24h (or more) is guaranteed to be discarded.
            :::

            ::: {.note}
            If `retention.size` is set, data may be discarded earlier than the specified time.
            :::
          '';
        };
      };
      dirs = {
        log = optionalPath { description = "Where to store below's logs"; };
        store = optionalPath {
          description = "Where to store below's data";
          example = "/var/lib/below";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.below ];
    # /etc/below.conf is also refered to by the `below` CLI tool,
    #  so this can't be a store-only file whose path is passed to the service
    environment.etc."below/below.conf".text = cfgContents;

    systemd = {
      packages = [ pkgs.below ];
      services.below = {
        # Workaround for https://github.com/NixOS/nixpkgs/issues/81138
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ cfgContents ];

        serviceConfig.ExecStart = [
          ""
          ("${lib.getExe pkgs.below} record " + (concatStringsSep " " (
            optional (!cfg.collect.diskStats) "--disable-disk-stat" ++
            optional   cfg.collect.ioStats    "--collect-io-stat"   ++
            optional (!cfg.collect.exitStats) "--disable-exitstats" ++
            optional   cfg.compression.enable "--compress"          ++

            optional (cfg.retention.size != null) "--store-size-limit ${toString cfg.retention.size}" ++
            optional (cfg.retention.time != null) "--retain-for-s ${toString cfg.retention.time}"
          )))
        ];
      };
    };
  };
}
