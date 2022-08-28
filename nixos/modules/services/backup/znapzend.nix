{ config, lib, pkgs, ... }:

with lib;
with types;

let

  planDescription = ''
      The znapzend backup plan to use for the source.

      The plan specifies how often to backup and for how long to keep the
      backups. It consists of a series of retention periodes to interval
      associations:

      <literal>
        retA=>intA,retB=>intB,...
      </literal>

      Both intervals and retention periods are expressed in standard units
      of time or multiples of them. You can use both the full name or a
      shortcut according to the following listing:

      <literal>
        second|sec|s, minute|min, hour|h, day|d, week|w, month|mon|m, year|y
      </literal>

      See <citerefentry><refentrytitle>znapzendzetup</refentrytitle><manvolnum>1</manvolnum></citerefentry> for more info.
  '';
  planExample = "1h=>10min,1d=>1h,1w=>1d,1m=>1w,1y=>1m";

  # A type for a string of the form number{b|k|M|G}
  mbufferSizeType = str // {
    check = x: str.check x && builtins.isList (builtins.match "^[0-9]+[bkMG]$" x);
    description = "string of the form number{b|k|M|G}";
  };

  enabledFeatures = concatLists (mapAttrsToList (name: enabled: optional enabled name) cfg.features);

  # Type for a string that must contain certain other strings (the list parameter).
  # Note that these would need regex escaping.
  stringContainingStrings = list: let
    matching = s: map (str: builtins.match ".*${str}.*" s) list;
  in str // {
    check = x: str.check x && all isList (matching x);
    description = "string containing all of the characters ${concatStringsSep ", " list}";
  };

  timestampType = stringContainingStrings [ "%Y" "%m" "%d" "%H" "%M" "%S" ];

  destType = srcConfig: submodule ({ name, ... }: {
    options = {

      label = mkOption {
        type = str;
        description = lib.mdDoc "Label for this destination. Defaults to the attribute name.";
      };

      plan = mkOption {
        type = str;
        description = planDescription;
        example = planExample;
      };

      dataset = mkOption {
        type = str;
        description = lib.mdDoc "Dataset name to send snapshots to.";
        example = "tank/main";
      };

      host = mkOption {
        type = nullOr str;
        description = lib.mdDoc ''
          Host to use for the destination dataset. Can be prefixed with
          `user@` to specify the ssh user.
        '';
        default = null;
        example = "john@example.com";
      };

      presend = mkOption {
        type = nullOr str;
        description = lib.mdDoc ''
          Command to run before sending the snapshot to the destination.
          Intended to run a remote script via {command}`ssh` on the
          destination, e.g. to bring up a backup disk or server or to put a
          zpool online/offline. See also {option}`postsend`.
        '';
        default = null;
        example = "ssh root@bserv zpool import -Nf tank";
      };

      postsend = mkOption {
        type = nullOr str;
        description = lib.mdDoc ''
          Command to run after sending the snapshot to the destination.
          Intended to run a remote script via {command}`ssh` on the
          destination, e.g. to bring up a backup disk or server or to put a
          zpool online/offline. See also {option}`presend`.
        '';
        default = null;
        example = "ssh root@bserv zpool export tank";
      };
    };

    config = {
      label = mkDefault name;
      plan = mkDefault srcConfig.plan;
    };
  });



  srcType = submodule ({ name, config, ... }: {
    options = {

      enable = mkOption {
        type = bool;
        description = lib.mdDoc "Whether to enable this source.";
        default = true;
      };

      recursive = mkOption {
        type = bool;
        description = lib.mdDoc "Whether to do recursive snapshots.";
        default = false;
      };

      mbuffer = {
        enable = mkOption {
          type = bool;
          description = lib.mdDoc "Whether to use {command}`mbuffer`.";
          default = false;
        };

        port = mkOption {
          type = nullOr ints.u16;
          description = lib.mdDoc ''
              Port to use for {command}`mbuffer`.

              If this is null, it will run {command}`mbuffer` through
              ssh.

              If this is not null, it will run {command}`mbuffer`
              directly through TCP, which is not encrypted but faster. In that
              case the given port needs to be open on the destination host.
          '';
          default = null;
        };

        size = mkOption {
          type = mbufferSizeType;
          description = lib.mdDoc ''
            The size for {command}`mbuffer`.
            Supports the units b, k, M, G.
          '';
          default = "1G";
          example = "128M";
        };
      };

      presnap = mkOption {
        type = nullOr str;
        description = lib.mdDoc ''
          Command to run before snapshots are taken on the source dataset,
          e.g. for database locking/flushing. See also
          {option}`postsnap`.
        '';
        default = null;
        example = literalExpression ''
          '''''${pkgs.mariadb}/bin/mysql -e "set autocommit=0;flush tables with read lock;\\! ''${pkgs.coreutils}/bin/sleep 600" &  ''${pkgs.coreutils}/bin/echo $! > /tmp/mariadblock.pid ; sleep 10'''
        '';
      };

      postsnap = mkOption {
        type = nullOr str;
        description = lib.mdDoc ''
          Command to run after snapshots are taken on the source dataset,
          e.g. for database unlocking. See also {option}`presnap`.
        '';
        default = null;
        example = literalExpression ''
          "''${pkgs.coreutils}/bin/kill `''${pkgs.coreutils}/bin/cat /tmp/mariadblock.pid`;''${pkgs.coreutils}/bin/rm /tmp/mariadblock.pid"
        '';
      };

      timestampFormat = mkOption {
        type = timestampType;
        description = lib.mdDoc ''
          The timestamp format to use for constructing snapshot names.
          The syntax is `strftime`-like. The string must
          consist of the mandatory `%Y %m %d %H %M %S`.
          Optionally  `- _ . :`  characters as well as any
          alphanumeric character are allowed. If suffixed by a
          `Z`, times will be in UTC.
        '';
        default = "%Y-%m-%d-%H%M%S";
        example = "znapzend-%m.%d.%Y-%H%M%SZ";
      };

      sendDelay = mkOption {
        type = int;
        description = lib.mdDoc ''
          Specify delay (in seconds) before sending snaps to the destination.
          May be useful if you want to control sending time.
        '';
        default = 0;
        example = 60;
      };

      plan = mkOption {
        type = str;
        description = planDescription;
        example = planExample;
      };

      dataset = mkOption {
        type = str;
        description = lib.mdDoc "The dataset to use for this source.";
        example = "tank/home";
      };

      destinations = mkOption {
        type = attrsOf (destType config);
        description = lib.mdDoc "Additional destinations.";
        default = {};
        example = literalExpression ''
          {
            local = {
              dataset = "btank/backup";
              presend = "zpool import -N btank";
              postsend = "zpool export btank";
            };
            remote = {
              host = "john@example.com";
              dataset = "tank/john";
            };
          };
        '';
      };
    };

    config = {
      dataset = mkDefault name;
    };

  });

  ### Generating the configuration from here

  cfg = config.services.znapzend;

  onOff = b: if b then "on" else "off";
  nullOff = b: if b == null then "off" else toString b;
  stripSlashes = replaceStrings [ "/" ] [ "." ];

  attrsToFile = config: concatStringsSep "\n" (builtins.attrValues (
    mapAttrs (n: v: "${n}=${v}") config));

  mkDestAttrs = dst: with dst;
    mapAttrs' (n: v: nameValuePair "dst_${label}${n}" v) ({
      "" = optionalString (host != null) "${host}:" + dataset;
      _plan = plan;
    } // optionalAttrs (presend != null) {
      _precmd = presend;
    } // optionalAttrs (postsend != null) {
      _pstcmd = postsend;
    });

  mkSrcAttrs = srcCfg: with srcCfg; {
    enabled = onOff enable;
    # mbuffer is not referenced by its full path to accomodate non-NixOS systems or differing mbuffer versions between source and target
    mbuffer = with mbuffer; if enable then "mbuffer"
        + optionalString (port != null) ":${toString port}" else "off";
    mbuffer_size = mbuffer.size;
    post_znap_cmd = nullOff postsnap;
    pre_znap_cmd = nullOff presnap;
    recursive = onOff recursive;
    src = dataset;
    src_plan = plan;
    tsformat = timestampFormat;
    zend_delay = toString sendDelay;
  } // foldr (a: b: a // b) {} (
    map mkDestAttrs (builtins.attrValues destinations)
  );

  files = mapAttrs' (n: srcCfg: let
    fileText = attrsToFile (mkSrcAttrs srcCfg);
  in {
    name = srcCfg.dataset;
    value = pkgs.writeText (stripSlashes srcCfg.dataset) fileText;
  }) cfg.zetup;

in
{
  options = {
    services.znapzend = {
      enable = mkEnableOption (lib.mdDoc "ZnapZend ZFS backup daemon");

      logLevel = mkOption {
        default = "debug";
        example = "warning";
        type = enum ["debug" "info" "warning" "err" "alert"];
        description = lib.mdDoc ''
          The log level when logging to file. Any of debug, info, warning, err,
          alert. Default in daemonized form is debug.
        '';
      };

      logTo = mkOption {
        type = str;
        default = "syslog::daemon";
        example = "/var/log/znapzend.log";
        description = lib.mdDoc ''
          Where to log to (syslog::\<facility\> or \<filepath\>).
        '';
      };

      noDestroy = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc "Does all changes to the filesystem except destroy.";
      };

      autoCreation = mkOption {
        type = bool;
        default = false;
        description = lib.mdDoc "Automatically create the destination dataset if it does not exist.";
      };

      zetup = mkOption {
        type = attrsOf srcType;
        description = lib.mdDoc "Znapzend configuration.";
        default = {};
        example = literalExpression ''
          {
            "tank/home" = {
              # Make snapshots of tank/home every hour, keep those for 1 day,
              # keep every days snapshot for 1 month, etc.
              plan = "1d=>1h,1m=>1d,1y=>1m";
              recursive = true;
              # Send all those snapshots to john@example.com:rtank/john as well
              destinations.remote = {
                host = "john@example.com";
                dataset = "rtank/john";
              };
            };
          };
        '';
      };

      pure = mkOption {
        type = bool;
        description = lib.mdDoc ''
          Do not persist any stateful znapzend setups. If this option is
          enabled, your previously set znapzend setups will be cleared and only
          the ones defined with this module will be applied.
        '';
        default = false;
      };

      features.oracleMode = mkEnableOption (lib.mdDoc ''
        Destroy snapshots one by one instead of using one long argument list.
        If source and destination are out of sync for a long time, you may have
        so many snapshots to destroy that the argument gets is too long and the
        command fails.
      '');
      features.recvu = mkEnableOption (lib.mdDoc ''
        recvu feature which uses `-u` on the receiving end to keep the destination
        filesystem unmounted.
      '');
      features.compressed = mkEnableOption (lib.mdDoc ''
        compressed feature which adds the options `-Lce` to
        the {command}`zfs send` command. When this is enabled, make
        sure that both the sending and receiving pool have the same relevant
        features enabled. Using `-c` will skip unneccessary
        decompress-compress stages, `-L` is for large block
        support and -e is for embedded data support. see
        {manpage}`znapzend(1)`
        and {manpage}`zfs(8)`
        for more info.
      '');
      features.sendRaw = mkEnableOption (lib.mdDoc ''
        sendRaw feature which adds the options `-w` to the
        {command}`zfs send` command. For encrypted source datasets this
        instructs zfs not to decrypt before sending which results in a remote
        backup that can't be read without the encryption key/passphrase, useful
        when the remote isn't fully trusted or not physically secure. This
        option must be used consistently, raw incrementals cannot be based on
        non-raw snapshots and vice versa.
      '');
      features.skipIntermediates = mkEnableOption (lib.mdDoc ''
        Enable the skipIntermediates feature to send a single increment
        between latest common snapshot and the newly made one. It may skip
        several source snaps if the destination was offline for some time, and
        it should skip snapshots not managed by znapzend. Normally for online
        destinations, the new snapshot is sent as soon as it is created on the
        source, so there are no automatic increments to skip.
      '');
      features.lowmemRecurse = mkEnableOption (lib.mdDoc ''
        use lowmemRecurse on systems where you have too many datasets, so a
        recursive listing of attributes to find backup plans exhausts the
        memory available to {command}`znapzend`: instead, go the slower
        way to first list all impacted dataset names, and then query their
        configs one by one.
      '');
      features.zfsGetType = mkEnableOption (lib.mdDoc ''
        use zfsGetType if your {command}`zfs get` supports a
        `-t` argument for filtering by dataset type at all AND
        lists properties for snapshots by default when recursing, so that there
        is too much data to process while searching for backup plans.
        If these two conditions apply to your system, the time needed for a
        `--recursive` search for backup plans can literally
        differ by hundreds of times (depending on the amount of snapshots in
        that dataset tree... and a decent backup plan will ensure you have a lot
        of those), so you would benefit from requesting this feature.
      '');
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.znapzend ];

    systemd.services = {
      znapzend = {
        description = "ZnapZend - ZFS Backup System";
        wantedBy    = [ "zfs.target" ];
        after       = [ "zfs.target" ];

        path = with pkgs; [ zfs mbuffer openssh ];

        preStart = optionalString cfg.pure ''
          echo Resetting znapzend zetups
          ${pkgs.znapzend}/bin/znapzendzetup list \
            | grep -oP '(?<=\*\*\* backup plan: ).*(?= \*\*\*)' \
            | xargs -I{} ${pkgs.znapzend}/bin/znapzendzetup delete "{}"
        '' + concatStringsSep "\n" (mapAttrsToList (dataset: config: ''
          echo Importing znapzend zetup ${config} for dataset ${dataset}
          ${pkgs.znapzend}/bin/znapzendzetup import --write ${dataset} ${config} &
        '') files) + ''
          wait
        '';

        serviceConfig = {
          # znapzendzetup --import apparently tries to connect to the backup
          # host 3 times with a timeout of 30 seconds, leading to a startup
          # delay of >90s when the host is down, which is just above the default
          # service timeout of 90 seconds. Increase the timeout so it doesn't
          # make the service fail in that case.
          TimeoutStartSec = 180;
          # Needs to have write access to ZFS
          User = "root";
          ExecStart = let
            args = concatStringsSep " " [
              "--logto=${cfg.logTo}"
              "--loglevel=${cfg.logLevel}"
              (optionalString cfg.noDestroy "--nodestroy")
              (optionalString cfg.autoCreation "--autoCreation")
              (optionalString (enabledFeatures != [])
                "--features=${concatStringsSep "," enabledFeatures}")
            ]; in "${pkgs.znapzend}/bin/znapzend ${args}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
        };
      };
    };
  };

  meta.maintainers = with maintainers; [ infinisil SlothOfAnarchy ];
}
