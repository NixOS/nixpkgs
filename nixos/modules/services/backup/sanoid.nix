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
      description = lib.mdDoc "Number of hourly snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    daily = mkOption {
      description = lib.mdDoc "Number of daily snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    monthly = mkOption {
      description = lib.mdDoc "Number of monthly snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    yearly = mkOption {
      description = lib.mdDoc "Number of yearly snapshots.";
      type = with types; nullOr ints.unsigned;
      default = null;
    };

    autoprune = mkOption {
      description = lib.mdDoc "Whether to automatically prune old snapshots.";
      type = with types; nullOr bool;
      default = null;
    };

    autosnap = mkOption {
      description = lib.mdDoc "Whether to automatically take snapshots.";
      type = with types; nullOr bool;
      default = null;
    };
  };

  datasetOptions = rec {
    use_template = mkOption {
      description = lib.mdDoc "Names of the templates to use for this dataset.";
      type = types.listOf (types.str // {
        check = (types.enum (attrNames cfg.templates)).check;
        description = "configured template name";
      });
      default = [ ];
    };
    useTemplate = use_template;

    recursive = mkOption {
      description = lib.mdDoc ''
        Whether to recursively snapshot dataset children.
        You can also set this to `"zfs"` to handle datasets
        recursively in an atomic way without the possibility to
        override settings for child datasets.
      '';
      type = with types; oneOf [ bool (enum [ "zfs" ]) ];
      default = false;
    };

    process_children_only = mkOption {
      description = lib.mdDoc "Whether to only snapshot child datasets if recursing.";
      type = types.bool;
      default = false;
    };
    processChildrenOnly = process_children_only;
  };

  # Extract unique dataset names
  datasets = unique (attrNames cfg.datasets);

  # Function to build "zfs allow" and "zfs unallow" commands for the
  # filesystems we've delegated permissions to.
  buildAllowCommand = zfsAction: permissions: dataset: lib.escapeShellArgs [
    # Here we explicitly use the booted system to guarantee the stable API needed by ZFS
    "-+/run/booted-system/sw/bin/zfs"
    zfsAction
    "sanoid"
    (concatStringsSep "," permissions)
    dataset
  ];

  configFile =
    let
      mkValueString = v:
        if builtins.isList v then concatStringsSep "," v
        else generators.mkValueStringDefault { } v;

      mkKeyValue = k: v:
        if v == null then ""
        else if k == "processChildrenOnly" then ""
        else if k == "useTemplate" then ""
        else generators.mkKeyValueDefault { inherit mkValueString; } "=" k v;
    in
    generators.toINI { inherit mkKeyValue; } cfg.settings;

in
{

  # Interface

  options.services.sanoid = {
    enable = mkEnableOption "Sanoid ZFS snapshotting service";

    interval = mkOption {
      type = types.str;
      default = "hourly";
      example = "daily";
      description = lib.mdDoc ''
        Run sanoid at this interval. The default is to run hourly.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    datasets = mkOption {
      type = types.attrsOf (types.submodule ({ config, options, ... }: {
        freeformType = datasetSettingsType;
        options = commonOptions // datasetOptions;
        config.use_template = mkAliasDefinitions (mkDefault options.useTemplate or { });
        config.process_children_only = mkAliasDefinitions (mkDefault options.processChildrenOnly or { });
      }));
      default = { };
      description = lib.mdDoc "Datasets to snapshot.";
    };

    templates = mkOption {
      type = types.attrsOf (types.submodule {
        freeformType = datasetSettingsType;
        options = commonOptions;
      });
      default = { };
      description = lib.mdDoc "Templates for datasets.";
    };

    settings = mkOption {
      type = types.attrsOf datasetSettingsType;
      description = lib.mdDoc ''
        Free-form settings written directly to the config file. See
        <https://github.com/jimsalterjrs/sanoid/blob/master/sanoid.defaults.conf>
        for allowed values.
      '';
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--verbose" "--readonly" "--debug" ];
      description = lib.mdDoc ''
        Extra arguments to pass to sanoid. See
        <https://github.com/jimsalterjrs/sanoid/#sanoid-command-line-options>
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
        ExecStartPre = (map (buildAllowCommand "allow" [ "snapshot" "mount" "destroy" ]) datasets);
        ExecStopPost = (map (buildAllowCommand "unallow" [ "snapshot" "mount" "destroy" ]) datasets);
        ExecStart = lib.escapeShellArgs ([
          "${pkgs.sanoid}/bin/sanoid"
          "--cron"
          "--configdir"
          (pkgs.writeTextDir "sanoid.conf" configFile)
        ] ++ cfg.extraArgs);
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
