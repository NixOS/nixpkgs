{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sanoid;

  datasetSettingsType = with types;
    (attrsOf (nullOr (oneOf [ str int bool (listOf str) ]))) // {
      description = "dataset/template options";
    };

  commonOptions = {
    hourly = mkOption {
      description = "Number of hourly snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    daily = mkOption {
      description = "Number of daily snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    monthly = mkOption {
      description = "Number of monthly snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    yearly = mkOption {
      description = "Number of yearly snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    autoprune = mkOption {
      description = "Whether to automatically prune old snapshots.";
      type = with types; nullOr bool;
      default = null;
    };

    autosnap = mkOption {
      description = "Whether to automatically take snapshots.";
      type = with types; nullOr bool;
      default = null;
    };
  };

  datasetOptions = rec {
    use_template = mkOption {
      description = "Names of the templates to use for this dataset.";
      type = types.listOf (types.enum (attrNames cfg.templates));
      default = [];
    };
    useTemplate = use_template;

    recursive = mkOption {
      description = "Whether to recursively snapshot dataset children.";
      type = types.bool;
      default = false;
    };

    process_children_only = mkOption {
      description = "Whether to only snapshot child datasets if recursing.";
      type = types.bool;
      default = false;
    };
    processChildrenOnly = process_children_only;
  };

  # Extract pool names from configured datasets
  pools = unique (map (d: head (builtins.match "([^/]+).*" d)) (attrNames cfg.datasets));

  configFile = let
    mkValueString = v:
      if builtins.isList v then concatStringsSep "," v
      else generators.mkValueStringDefault {} v;

    mkKeyValue = k: v: if v == null then ""
      else if k == "processChildrenOnly" then ""
      else if k == "useTemplate" then ""
      else generators.mkKeyValueDefault { inherit mkValueString; } "=" k v;
  in generators.toINI { inherit mkKeyValue; } cfg.settings;

in {

    # Interface

    options.services.sanoid = {
      enable = mkEnableOption "Sanoid ZFS snapshotting service";

      interval = mkOption {
        type = types.str;
        default = "hourly";
        example = "daily";
        description = ''
          Run sanoid at this interval. The default is to run hourly.

          The format is described in
          <citerefentry><refentrytitle>systemd.time</refentrytitle>
          <manvolnum>7</manvolnum></citerefentry>.
        '';
      };

      datasets = mkOption {
        type = types.attrsOf (types.submodule ({config, options, ...}: {
          freeformType = datasetSettingsType;
          options = commonOptions // datasetOptions;
          config.use_template = mkAliasDefinitions (options.useTemplate or {});
          config.process_children_only = mkAliasDefinitions (options.processChildrenOnly or {});
        }));
        default = {};
        description = "Datasets to snapshot.";
      };

      templates = mkOption {
        type = types.attrsOf (types.submodule {
          freeformType = datasetSettingsType;
          options = commonOptions;
        });
        default = {};
        description = "Templates for datasets.";
      };

      settings = mkOption {
        type = types.attrsOf datasetSettingsType;
        description = ''
          Free-form settings written directly to the config file. See
          <link xlink:href="https://github.com/jimsalterjrs/sanoid/blob/master/sanoid.defaults.conf"/>
          for allowed values.
        '';
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "--verbose" "--readonly" "--debug" ];
        description = ''
          Extra arguments to pass to sanoid. See
          <link xlink:href="https://github.com/jimsalterjrs/sanoid/#sanoid-command-line-options"/>
          for allowed options.
        '';
      };
    };

    # Implementation

    config = mkIf cfg.enable {
      services.sanoid.settings = mkMerge [
        (mapAttrs' (d: v: nameValuePair ("template_" + d) v) cfg.templates)
        (mapAttrs (d: v: v) cfg.datasets)
      ];

      systemd.services.sanoid = {
        description = "Sanoid snapshot service";
        serviceConfig = {
          ExecStartPre = map (pool: lib.escapeShellArgs [
            "+/run/booted-system/sw/bin/zfs" "allow"
            "sanoid" "snapshot,mount,destroy" pool
          ]) pools;
          ExecStart = lib.escapeShellArgs ([
            "${pkgs.sanoid}/bin/sanoid"
            "--cron"
            "--configdir" (pkgs.writeTextDir "sanoid.conf" configFile)
          ] ++ cfg.extraArgs);
          ExecStopPost = map (pool: lib.escapeShellArgs [
            "+/run/booted-system/sw/bin/zfs" "unallow" "sanoid" pool
          ]) pools;
          User = "sanoid";
          Group = "sanoid";
          DynamicUser = true;
          RuntimeDirectory = "sanoid";
          CacheDirectory = "sanoid";
        };
        # Prevents missing snapshots during DST changes
        environment.TZ = "UTC";
        after = [ "zfs.target" ];
        startAt = cfg.interval;
      };
    };

    meta.maintainers = with maintainers; [ lopsided98 ];
  }
