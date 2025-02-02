{ config, lib, pkgs, ... }:
let
  cfg = config.services.sanoid;

  datasetSettingsType = with lib.types;
    (attrsOf (nullOr (oneOf [ str int bool (listOf str) ]))) // {
      description = "dataset/template options";
    };

  commonOptions = {
    hourly = lib.mkOption {
      description = "Number of hourly snapshots.";
      type = with lib.types; nullOr ints.unsigned;
      default = null;
    };

    daily = lib.mkOption {
      description = "Number of daily snapshots.";
      type = with lib.types; nullOr ints.unsigned;
      default = null;
    };

    monthly = lib.mkOption {
      description = "Number of monthly snapshots.";
      type = with lib.types; nullOr ints.unsigned;
      default = null;
    };

    yearly = lib.mkOption {
      description = "Number of yearly snapshots.";
      type = with lib.types; nullOr ints.unsigned;
      default = null;
    };

    autoprune = lib.mkOption {
      description = "Whether to automatically prune old snapshots.";
      type = with lib.types; nullOr bool;
      default = null;
    };

    autosnap = lib.mkOption {
      description = "Whether to automatically take snapshots.";
      type = with lib.types; nullOr bool;
      default = null;
    };
  };

  datasetOptions = rec {
    use_template = lib.mkOption {
      description = "Names of the templates to use for this dataset.";
      type = lib.types.listOf (lib.types.str // {
        check = (lib.types.enum (lib.attrNames cfg.templates)).check;
        description = "configured template name";
      });
      default = [ ];
    };
    useTemplate = use_template;

    recursive = lib.mkOption {
      description = ''
        Whether to recursively snapshot dataset children.
        You can also set this to `"zfs"` to handle datasets
        recursively in an atomic way without the possibility to
        override settings for child datasets.
      '';
      type = with lib.types; oneOf [ bool (enum [ "zfs" ]) ];
      default = false;
    };

    process_children_only = lib.mkOption {
      description = "Whether to only snapshot child datasets if recursing.";
      type = lib.types.bool;
      default = false;
    };
    processChildrenOnly = process_children_only;
  };

  # Extract unique dataset names
  datasets = lib.unique (lib.attrNames cfg.datasets);

  # Function to build "zfs allow" and "zfs unallow" commands for the
  # filesystems we've delegated permissions to.
  buildAllowCommand = zfsAction: permissions: dataset: lib.escapeShellArgs [
    # Here we explicitly use the booted system to guarantee the stable API needed by ZFS
    "-+/run/booted-system/sw/bin/zfs"
    zfsAction
    "sanoid"
    (lib.concatStringsSep "," permissions)
    dataset
  ];

  configFile =
    let
      mkValueString = v:
        if lib.isList v then lib.concatStringsSep "," v
        else lib.generators.mkValueStringDefault { } v;

      mkKeyValue = k: v:
        if v == null then ""
        else if k == "processChildrenOnly" then ""
        else if k == "useTemplate" then ""
        else lib.generators.mkKeyValueDefault { inherit mkValueString; } "=" k v;
    in
    lib.generators.toINI { inherit mkKeyValue; } cfg.settings;

in
{

  # Interface

  options.services.sanoid = {
    enable = lib.mkEnableOption "Sanoid ZFS snapshotting service";

    package = lib.mkPackageOption pkgs "sanoid" {};

    interval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      example = "daily";
      description = ''
        Run sanoid at this interval. The default is to run hourly.

        The format is described in
        {manpage}`systemd.time(7)`.
      '';
    };

    datasets = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({ config, options, ... }: {
        freeformType = datasetSettingsType;
        options = commonOptions // datasetOptions;
        config.use_template = lib.modules.mkAliasAndWrapDefsWithPriority lib.id (options.useTemplate or { });
        config.process_children_only = lib.modules.mkAliasAndWrapDefsWithPriority lib.id (options.processChildrenOnly or { });
      }));
      default = { };
      description = "Datasets to snapshot.";
    };

    templates = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        freeformType = datasetSettingsType;
        options = commonOptions;
      });
      default = { };
      description = "Templates for datasets.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf datasetSettingsType;
      description = ''
        Free-form settings written directly to the config file. See
        <https://github.com/jimsalterjrs/sanoid/blob/master/sanoid.defaults.conf>
        for allowed values.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--verbose" "--readonly" "--debug" ];
      description = ''
        Extra arguments to pass to sanoid. See
        <https://github.com/jimsalterjrs/sanoid/#sanoid-command-line-options>
        for allowed options.
      '';
    };
  };

  # Implementation

  config = lib.mkIf cfg.enable {
    services.sanoid.settings = lib.mkMerge [
      (lib.mapAttrs' (d: v: lib.nameValuePair ("template_" + d) v) cfg.templates)
      (lib.mapAttrs (d: v: v) cfg.datasets)
    ];

    systemd.services.sanoid = {
      description = "Sanoid snapshot service";
      serviceConfig = {
        ExecStartPre = (map (buildAllowCommand "allow" [ "snapshot" "mount" "destroy" ]) datasets);
        ExecStopPost = (map (buildAllowCommand "unallow" [ "snapshot" "mount" "destroy" ]) datasets);
        ExecStart = lib.escapeShellArgs ([
          "${cfg.package}/bin/sanoid"
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

  meta.maintainers = with lib.maintainers; [ lopsided98 ];
}
