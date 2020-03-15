{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sanoid;

  datasetSettingsType = with types;
    (attrsOf (nullOr (oneOf [ str int bool (listOf str) ]))) // {
      description = "dataset/template options";
    };

  # Default values from https://github.com/jimsalterjrs/sanoid/blob/master/sanoid.defaults.conf

  commonOptions = {
    hourly = mkOption {
      description = "Number of hourly snapshots.";
      type = types.ints.unsigned;
      default = 48;
    };

    daily = mkOption {
      description = "Number of daily snapshots.";
      type = types.ints.unsigned;
      default = 90;
    };

    monthly = mkOption {
      description = "Number of monthly snapshots.";
      type = types.ints.unsigned;
      default = 6;
    };

    yearly = mkOption {
      description = "Number of yearly snapshots.";
      type = types.ints.unsigned;
      default = 0;
    };

    autoprune = mkOption {
      description = "Whether to automatically prune old snapshots.";
      type = types.bool;
      default = true;
    };

    autosnap = mkOption {
      description = "Whether to automatically take snapshots.";
      type = types.bool;
      default = true;
    };

    settings = mkOption {
      description = ''
        Free-form settings for this template/dataset. See
        <link xlink:href="https://github.com/jimsalterjrs/sanoid/blob/master/sanoid.defaults.conf"/>
        for allowed values.
      '';
      type = datasetSettingsType;
    };
  };

  commonConfig = config: {
    settings = {
      hourly = mkDefault config.hourly;
      daily = mkDefault config.daily;
      monthly = mkDefault config.monthly;
      yearly = mkDefault config.yearly;
      autoprune = mkDefault config.autoprune;
      autosnap = mkDefault config.autosnap;
    };
  };

  datasetOptions = {
    useTemplate = mkOption {
      description = "Names of the templates to use for this dataset.";
      type = (types.listOf (types.enum (attrNames cfg.templates))) // {
        description = "list of template names";
      };
      default = [];
    };

    recursive = mkOption {
      description = "Whether to recursively snapshot dataset children.";
      type = types.bool;
      default = false;
    };

    processChildrenOnly = mkOption {
      description = "Whether to only snapshot child datasets if recursing.";
      type = types.bool;
      default = false;
    };
  };

  datasetConfig = config: {
    settings = {
      use_template = mkDefault config.useTemplate;
      recursive = mkDefault config.recursive;
      process_children_only = mkDefault config.processChildrenOnly;
    };
  };

  # Extract pool names from configured datasets
  pools = unique (map (d: head (builtins.match "([^/]+).*" d)) (attrNames cfg.datasets));

  configFile = let
    mkValueString = v:
      if builtins.isList v then concatStringsSep "," v
      else generators.mkValueStringDefault {} v;

    mkKeyValue = k: v: if v == null then ""
      else generators.mkKeyValueDefault { inherit mkValueString; } "=" k v;
  in generators.toINI { inherit mkKeyValue; } cfg.settings;

  configDir = pkgs.writeTextDir "sanoid.conf" configFile;

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
        type = types.attrsOf (types.submodule ({ config, ... }: {
          options = commonOptions // datasetOptions;
          config = mkMerge [ (commonConfig config) (datasetConfig config) ];
        }));
        default = {};
        description = "Datasets to snapshot.";
      };

      templates = mkOption {
        type = types.attrsOf (types.submodule ({ config, ... }: {
          options = commonOptions;
          config = commonConfig config;
        }));
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
        (mapAttrs' (d: v: nameValuePair ("template_" + d) v.settings) cfg.templates)
        (mapAttrs (d: v: v.settings) cfg.datasets)
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
            "--configdir" configDir
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
