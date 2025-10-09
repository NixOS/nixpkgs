{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    concatLines
    concatStringsSep
    mapAttrsToList
    optional
    optionals

    mkIf
    mkOption
    types
    ;

  cfg = config.hardware.block;
  escape = lib.strings.escape [ ''"'' ];

  udevValue = types.addCheck types.nonEmptyStr (x: builtins.match "[^\n\r]*" x != null) // {
    name = "udevValue";
    description = "udev rule value";
    descriptionClass = "noun";
  };

  udevRule =
    {
      rotational ? null,
      include ? null,
      exclude ? null,
      scheduler,
    }:
    concatStringsSep ", " (
      [
        ''SUBSYSTEM=="block"''
        ''ACTION=="add|change"''
        ''TEST=="queue/scheduler"''
      ]
      ++ optionals (rotational != null) [
        ''ATTR{queue/rotational}=="${if rotational then "1" else "0"}"''
      ]
      ++ optionals (include != null) [
        ''KERNEL=="${escape include}"''
      ]
      ++ optionals (exclude != null) [
        ''KERNEL!="${escape exclude}"''
      ]
      ++ [
        ''ATTR{queue/scheduler}="${escape scheduler}"''
      ]
    );
in
{
  options.hardware.block = {
    defaultScheduler = mkOption {
      type = types.nullOr udevValue;
      default = null;
      description = ''
        Default block I/O scheduler.

        Unless `null`, the value is assigned through a udev rule matching all
        block devices.
      '';
      example = "kyber";
    };

    defaultSchedulerRotational = mkOption {
      type = types.nullOr udevValue;
      default = null;
      description = ''
        Default block I/O scheduler for rotational drives (e.g. hard disks).

        Unless `null`, the value is assigned through a udev rule matching all
        rotational block devices.

        This option takes precedence over
        {option}`config.hardware.block.defaultScheduler`.
      '';
      example = "bfq";
    };

    defaultSchedulerExclude = mkOption {
      type = types.nullOr udevValue;
      default = "loop[0-9]*";
      description = ''
        Device name pattern to exclude from default scheduler assignment
        through {option}`config.hardware.block.defaultScheduler` and
        {option}`config.hardware.block.defaultSchedulerRotational`.

        By default this excludes loop devices which generally do not benefit
        from extra I/O scheduling in addition to the scheduling already
        performed for their backing devices.

        This setting does not affect {option}`config.hardware.block.scheduler`.
      '';
    };

    scheduler = mkOption {
      type = types.attrsOf udevValue;
      default = { };
      description = ''
        Assign block I/O scheduler by device name pattern.

        Names are matched using the {manpage}`udev(7)` pattern syntax:

        `*`
        :  Matches zero or more characters.

        `?`
        :  Matches any single character.

        `[]`
        :  Matches any single character specified in the brackets. Ranges are
           supported via the `-` character.

        `|`
        :  Separates alternative patterns.


        Please note that overlapping patterns may produce unexpected results.
        More complex configurations requiring these should instead be specified
        directly through custom udev rules, for example via
        [{option}`config.services.udev.extraRules`](#opt-services.udev.extraRules),
        to ensure correct ordering.

        Available schedulers depend on the kernel configuration but modern
        Linux systems typically support:

        `none`
        :  No‐operation scheduler with no re‐ordering of requests. Suitable
           for devices with fast random I/O such as NVMe SSDs.

        [`mq-deadline`](https://www.kernel.org/doc/html/latest/block/deadline-iosched.html)
        :  Simple latency‐oriented general‐purpose scheduler.

        [`kyber`](https://www.kernel.org/doc/html/latest/block/kyber-iosched.html)
        :  Simple latency‐oriented scheduler for fast multi‐queue devices
           like NVMe SSDs.

        [`bfq`](https://www.kernel.org/doc/html/latest/block/bfq-iosched.html)
        :  Complex fairness‐oriented scheduler. Higher processing overhead,
           but good interactive response, especially with slower devices.


        Schedulers assigned through this option take precedence over
        {option}`config.hardware.block.defaultScheduler` and
        {option}`config.hardware.block.defaultSchedulerRotational` but may be
        overridden by other udev rules.
      '';
      example = {
        "mmcblk[0-9]*" = "bfq";
        "nvme[0-9]*" = "kyber";
      };
    };
  };

  config =
    mkIf
      (cfg.defaultScheduler != null || cfg.defaultSchedulerRotational != null || cfg.scheduler != { })
      {
        services.udev.packages = [
          (pkgs.writeTextDir "etc/udev/rules.d/98-block-io-scheduler.rules" (
            concatLines (
              optional (cfg.defaultScheduler != null) (udevRule {
                exclude = cfg.defaultSchedulerExclude;
                scheduler = cfg.defaultScheduler;
              })
              ++ optional (cfg.defaultSchedulerRotational != null) (udevRule {
                rotational = true;
                exclude = cfg.defaultSchedulerExclude;
                scheduler = cfg.defaultSchedulerRotational;
              })
              ++ mapAttrsToList (
                include: scheduler:
                udevRule {
                  inherit include scheduler;
                }
              ) cfg.scheduler
            )
          ))
        ];
      };

  meta.maintainers = with lib.maintainers; [ mvs ];
}
