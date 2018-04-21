{ config, lib, pkgs, ... }:

with lib;
with types;

let

  # Converts a plan like
  #   { "1d" = "1h"; "1w" = "1d"; }
  # into
  #   "1d=>1h,1w=>1d"
  attrToPlan = attrs: concatStringsSep "," (builtins.attrValues (
    mapAttrs (n: v: "${n}=>${v}") attrs));

  planDescription = ''
      The znapzend backup plan to use for the source.
    </para>
    <para>
      The plan specifies how often to backup and for how long to keep the
      backups. It consists of a series of retention periodes to interval
      associations:
    </para>
    <para>
      <literal>
        retA=>intA,retB=>intB,...
      </literal>
    </para>
    <para>
    Both intervals and retention periods are expressed in standard units
    of time or multiples of them. You can use both the full name or a
    shortcut according to the following listing:
    </para>
    <para>
      <literal>
        second|sec|s, minute|min, hour|h, day|d, week|w, month|mon|m, year|y
      </literal>
    </para>
    <para>
      See <citerefentry><refentrytitle>znapzendzetup</refentrytitle><manvolnum>1</manvolnum></citerefentry> for more info.
  '';
  planExample = "1h=>10min,1d=>1h,1w=>1d,1m=>1w,1y=>1m";

  # A type for a string of the form number{b|k|M|G}
  mbufferSizeType = str // {
    check = x: str.check x && builtins.isList (builtins.match "^[0-9]+[bkMG]$" x);
    description = "string of the form number{b|k|M|G}";
  };

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
        description = "Label for this destination. Defaults to the attribute name.";
      };

      plan = mkOption {
        type = str;
        description = planDescription;
        example = planExample;
      };

      dataset = mkOption {
        type = str;
        description = "Dataset name to send snapshots to.";
        example = "tank/main";
      };

      host = mkOption {
        type = nullOr str;
        description = ''
          Host to use for the destination dataset. Can be prefixed with
          <literal>user@</literal> to specify the ssh user.
        '';
        default = null;
        example = "john@example.com";
      };

      presend = mkOption {
        type = nullOr str;
        description = ''
          Command to run before sending the snapshot to the destination.
          Intended to run a remote script via <command>ssh</command> on the
          destination, e.g. to bring up a backup disk or server or to put a
          zpool online/offline. See also <option>postsend</option>.
        '';
        default = null;
        example = "ssh root@bserv zpool import -Nf tank";
      };

      postsend = mkOption {
        type = nullOr str;
        description = ''
          Command to run after sending the snapshot to the destination.
          Intended to run a remote script via <command>ssh</command> on the
          destination, e.g. to bring up a backup disk or server or to put a
          zpool online/offline. See also <option>presend</option>.
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
        description = "Whether to enable this source.";
        default = true;
      };

      recursive = mkOption {
        type = bool;
        description = "Whether to do recursive snapshots.";
        default = false;
      };

      mbuffer = {
        enable = mkOption {
          type = bool;
          description = "Whether to use <command>mbuffer</command>.";
          default = false;
        };

        port = mkOption {
          type = nullOr ints.u16;
          description = ''
              Port to use for <command>mbuffer</command>.
            </para>
            <para>
              If this is null, it will run <command>mbuffer</command> through
              ssh.
            </para>
            <para>
              If this is not null, it will run <command>mbuffer</command>
              directly through TCP, which is not encrypted but faster. In that
              case the given port needs to be open on the destination host.
          '';
          default = null;
        };

        size = mkOption {
          type = mbufferSizeType;
          description = ''
            The size for <command>mbuffer</command>.
            Supports the units b, k, M, G.
          '';
          default = "1G";
          example = "128M";
        };
      };

      presnap = mkOption {
        type = nullOr str;
        description = ''
          Command to run before snapshots are taken on the source dataset,
          e.g. for database locking/flushing. See also
          <option>postsnap</option>.
        '';
        default = null;
        example = literalExample ''
          ''${pkgs.mariadb}/bin/mysql -e "set autocommit=0;flush tables with read lock;\\! ''${pkgs.coreutils}/bin/sleep 600" &  ''${pkgs.coreutils}/bin/echo $! > /tmp/mariadblock.pid ; sleep 10
        '';
      };

      postsnap = mkOption {
        type = nullOr str;
        description = ''
          Command to run after snapshots are taken on the source dataset,
          e.g. for database unlocking. See also <option>presnap</option>.
        '';
        default = null;
        example = literalExample ''
          ''${pkgs.coreutils}/bin/kill `''${pkgs.coreutils}/bin/cat /tmp/mariadblock.pid`;''${pkgs.coreutils}/bin/rm /tmp/mariadblock.pid
        '';
      };

      timestampFormat = mkOption {
        type = timestampType;
        description = ''
          The timestamp format to use for constructing snapshot names.
          The syntax is <literal>strftime</literal>-like. The string must
          consist of the mandatory <literal>%Y %m %d %H %M %S</literal>.
          Optionally  <literal>- _ . :</literal>  characters as well as any
          alphanumeric character are allowed. If suffixed by a
          <literal>Z</literal>, times will be in UTC.
        '';
        default = "%Y-%m-%d-%H%M%S";
        example = "znapzend-%m.%d.%Y-%H%M%SZ";
      };

      sendDelay = mkOption {
        type = int;
        description = ''
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
        description = "The dataset to use for this source.";
        example = "tank/home";
      };

      destinations = mkOption {
        type = loaOf (destType config);
        description = "Additional destinations.";
        default = {};
        example = literalExample ''
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
  nullOff = b: if isNull b then "off" else toString b;
  stripSlashes = replaceStrings [ "/" ] [ "." ];

  attrsToFile = config: concatStringsSep "\n" (builtins.attrValues (
    mapAttrs (n: v: "${n}=${v}") config));

  mkDestAttrs = dst: with dst;
    mapAttrs' (n: v: nameValuePair "dst_${label}${n}" v) ({
      "" = optionalString (! isNull host) "${host}:" + dataset;
      _plan = plan;
    } // optionalAttrs (presend != null) {
      _precmd = presend;
    } // optionalAttrs (postsend != null) {
      _pstcmd = postsend;
    });

  mkSrcAttrs = srcCfg: with srcCfg; {
    enabled = onOff enable;
    mbuffer = with mbuffer; if enable then "${pkgs.mbuffer}/bin/mbuffer"
        + optionalString (port != null) ":${toString port}" else "off";
    mbuffer_size = mbuffer.size;
    post_znap_cmd = nullOff postsnap;
    pre_znap_cmd = nullOff presnap;
    recursive = onOff recursive;
    src = dataset;
    src_plan = plan;
    tsformat = timestampFormat;
    zend_delay = toString sendDelay;
  } // fold (a: b: a // b) {} (
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
      enable = mkEnableOption "ZnapZend ZFS backup daemon";

      logLevel = mkOption {
        default = "debug";
        example = "warning";
        type = enum ["debug" "info" "warning" "err" "alert"];
        description = ''
          The log level when logging to file. Any of debug, info, warning, err,
          alert. Default in daemonized form is debug.
        '';
      };

      logTo = mkOption {
        type = str;
        default = "syslog::daemon";
        example = "/var/log/znapzend.log";
        description = ''
          Where to log to (syslog::&lt;facility&gt; or &lt;filepath&gt;).
        '';
      };

      noDestroy = mkOption {
        type = bool;
        default = false;
        description = "Does all changes to the filesystem except destroy.";
      };

      autoCreation = mkOption {
        type = bool;
        default = false;
        description = "Automatically create the destination dataset if it does not exists.";
      };

      zetup = mkOption {
        type = loaOf srcType;
        description = "Znapzend configuration.";
        default = {};
        example = literalExample ''
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
        description = ''
          Do not persist any stateful znapzend setups. If this option is
          enabled, your previously set znapzend setups will be cleared and only
          the ones defined with this module will be applied.
        '';
        default = false;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.znapzend ];

    systemd.services = {
      "znapzend" = {
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
          ${pkgs.znapzend}/bin/znapzendzetup import --write ${dataset} ${config}
        '') files);

        serviceConfig = {
          ExecStart = let
            args = concatStringsSep " " [
              "--logto=${cfg.logTo}"
              "--loglevel=${cfg.logLevel}"
              (optionalString cfg.noDestroy "--nodestroy")
              (optionalString cfg.autoCreation "--autoCreation")
            ]; in "${pkgs.znapzend}/bin/znapzend ${args}";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
        };
      };
    };
  };

  meta.maintainers = with maintainers; [ infinisil ];
}
