{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.system.autoUpgrade;

in
{

  options = {

    system.autoUpgrade = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to periodically upgrade NixOS to the latest
          version. If enabled, a systemd timer will run
          `nixos-rebuild switch --upgrade` once a
          day.
        '';
      };

      operation = lib.mkOption {
        type = lib.types.enum [
          "switch"
          "boot"
        ];
        default = "switch";
        example = "boot";
        description = ''
          Whether to run
          `nixos-rebuild switch --upgrade` or run
          `nixos-rebuild boot --upgrade`
        '';
      };

      flake = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "github:kloenk/nix";
        description = ''
          The Flake URI of the NixOS configuration to build.
          Disables the option {option}`system.autoUpgrade.channel`.
        '';
      };

      channel = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = "https://channels.nixos.org/nixos-14.12-small";
        description = ''
          The URI of the NixOS channel to use for automatic
          upgrades. By default, this is the channel set using
          {command}`nix-channel` (run `nix-channel --list`
          to see the current value).
        '';
      };

      upgrade = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Disable adding the `--upgrade` parameter when `channel`
          is not set, such as when upgrading to the latest version
          of a flake honouring its lockfile.
        '';
      };

      flags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "-I"
          "stuff=/home/alice/nixos-stuff"
          "--option"
          "extra-binary-caches"
          "http://my-cache.example.org/"
        ];
        description = ''
          Any additional flags passed to {command}`nixos-rebuild`.

          If you are using flakes and use a local repo you can add
          {command}`[ "--update-input" "nixpkgs" "--commit-lock-file" ]`
          to update nixpkgs.
        '';
      };

      dates = lib.mkOption {
        type = lib.types.str;
        default = "04:40";
        example = "daily";
        description = ''
          How often or when upgrade occurs. For most desktop and server systems
          a sufficient upgrade frequency is once a day.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      allowReboot = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Reboot the system into the new generation instead of a switch
          if the new generation uses a different kernel, kernel modules
          or initrd than the booted system.
          See {option}`rebootWindow` for configuring the times at which a reboot is allowed.
        '';
      };

      rebootTriggers = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = ''
          Attribute set of strings that will cause an auto-reboot when changed when
          {option}`system.autoUpgrade.allowReboot` is set to true.
        '';
        defaultText = lib.literalExpression ''
          {
            kernel = "''${config.system.build.kernel}";
            firmware = "''${config.hardware.firmware}";
            kernel-params = "''${pkgs.writeTextFile {
              name = "kernel-params";
              text = lib.concatStringsSep " " config.boot.kernelParams;
            }}";
          }
          // config.system.switch.inhibitors
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "0";
        type = lib.types.str;
        example = "45min";
        description = ''
          Add a randomized delay before each automatic upgrade.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      fixedRandomDelay = lib.mkOption {
        default = false;
        type = lib.types.bool;
        example = true;
        description = ''
          Make the randomized delay consistent between runs.
          This reduces the jitter between automatic upgrades.
          See {option}`randomizedDelaySec` for configuring the randomized delay.
        '';
      };

      rebootWindow = lib.mkOption {
        description = ''
          Define a lower and upper time value (in HH:MM format) which
          constitute a time window during which reboots are allowed after an upgrade.
          This option only has an effect when {option}`allowReboot` is enabled.
          The default value of `null` means that reboots are allowed at any time.
        '';
        default = null;
        example = {
          lower = "01:00";
          upper = "05:00";
        };
        type =
          with lib.types;
          nullOr (submodule {
            options = {
              lower = lib.mkOption {
                description = "Lower limit of the reboot window";
                type = lib.types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}";
                example = "01:00";
              };

              upper = lib.mkOption {
                description = "Upper limit of the reboot window";
                type = lib.types.strMatching "[[:digit:]]{2}:[[:digit:]]{2}";
                example = "05:00";
              };
            };
          });
      };

      persistent = lib.mkOption {
        default = true;
        type = lib.types.bool;
        example = false;
        description = ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
        '';
      };

      runGarbageCollection = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to automatically run `nix-gc.service` after a successful
          system upgrade.
        '';
      };

    };

  };

  config = lib.mkMerge [

    {
      system = {
        autoUpgrade.rebootTriggers = config.system.switch.inhibitors;

        systemBuilderCommands = ''
          ln -s ${config.system.build.rebootTriggers} $out/reboot-triggers
        '';

        build.rebootTriggers = pkgs.writers.writeJSON "reboot-triggers" config.system.autoUpgrade.rebootTriggers;
      };
    }

    (lib.mkIf (!config.boot.isContainer) {
      system.autoUpgrade.rebootTriggers = {
        kernel = lib.mkIf (config.system.build.kernel != null) "${config.system.build.kernel}";
        firmware = "${config.hardware.firmware}";
        kernel-params = lib.concatStringsSep "," config.boot.kernelParams;
      }
      // config.system.switch.inhibitors;
    })

    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !config.boot.isContainer;
          message = ''
            The option 'system.autoUpgrade.enable' cannot be enabled for a container.
          '';
        }
        {
          assertion = !((cfg.channel != null) && (cfg.flake != null));
          message = ''
            The options 'system.autoUpgrade.channel' and 'system.autoUpgrade.flake' cannot both be set.
          '';
        }
        {
          assertion = (cfg.runGarbageCollection -> config.nix.enable);
          message = ''
            The option 'system.autoUpgrade.runGarbageCollection = true' requires 'nix.enable = true'.
          '';
        }
      ];

      system.autoUpgrade.flags = (
        if cfg.flake == null then
          [ "--no-build-output" ]
          ++ lib.optionals (cfg.channel != null) [
            "-I"
            "nixpkgs=${cfg.channel}/nixexprs.tar.xz"
          ]
        else
          [
            "--refresh"
            "--flake ${cfg.flake}"
          ]
      );

      systemd.services.nixos-upgrade = {
        description = "NixOS Upgrade";

        restartIfChanged = false;
        unitConfig.X-StopOnRemoval = false;
        unitConfig.OnSuccess = lib.optional (
          cfg.runGarbageCollection && config.nix.enable
        ) "nix-gc.service";

        serviceConfig.Type = "oneshot";

        environment =
          config.nix.envVars
          // {
            inherit (config.environment.sessionVariables) NIX_PATH;
            HOME = "/root";
          }
          // config.networking.proxy.envVars;

        path = with pkgs; [
          coreutils
          gnutar
          jq
          xz.bin
          gzip
          gitMinimal
          config.nix.package.out
          config.programs.ssh.package
          config.system.build.nixos-rebuild
          config.systemd.package
        ];

        script =
          let
            upgradeFlag = lib.optional (cfg.channel == null && cfg.flake == null) "--upgrade";
          in
          if cfg.allowReboot then
            # bash
            ''
              echo "Running nixos-rebuild boot..."
              new_configuration="$(
                # For some reason we still get a newline here in the journal between the
                # nixos-rebuild stderr output and us echoing the store path that was
                # printed on stdout.
                # This might have to do with the particular way in which systemd handles
                # stdout/stderr, they are unix sockets and not normal streams.
                store_path="$(nixos-rebuild boot ${toString (cfg.flags ++ upgradeFlag)})"
                echo "$store_path" >&2
                echo "$store_path"
              )"
              if [ -z "$new_configuration" ]; then
                echo "Looks like nixos-rebuild failed... Aborting"
                exit 1
              fi
              echo "New configuration is $new_configuration"
              switch_to_new_configuration="$new_configuration"/bin/switch-to-configuration

              ${lib.optionalString (cfg.rebootWindow != null) # bash
                ''
                  current_time="$(date +%H:%M)"

                  lower="${cfg.rebootWindow.lower}"
                  upper="${cfg.rebootWindow.upper}"

                  if [[ "''${lower}" < "''${upper}" ]]; then
                    if [[ "''${current_time}" > "''${lower}" ]] && [[ "''${current_time}" < "''${upper}" ]]; then
                      do_reboot="true"
                    else
                      do_reboot="false"
                    fi
                  else
                    # lower > upper, so we are crossing midnight (e.g. lower=23h, upper=6h)
                    # we want to reboot if cur > 23h or cur < 6h
                    if [[ "''${current_time}" < "''${upper}" ]] || [[ "''${current_time}" > "''${lower}" ]]; then
                      do_reboot="true"
                    else
                      do_reboot="false"
                    fi
                  fi
                ''
              }

              # Create a temporary file that we use in case a generation does not have
              # the reboot-triggers file.
              empty="$(mktemp -t nixos-reboot-triggers.XXXX)"
              # shellcheck disable=SC2329
              clean_up() {
                rm -f "$empty"
              }
              trap clean_up EXIT
              echo "{}" > "$empty"

              booted_triggers="$(realpath /run/booted-system)/reboot-triggers"
              if [ ! -f "$booted_triggers" ]; then
                booted_triggers="$empty"
              fi

              new_triggers="$(realpath "$new_configuration")/reboot-triggers"
              if [ ! -f "$new_triggers" ]; then
                new_triggers="$empty"
              fi

              diff="$(
                jq \
                  --raw-output \
                  --null-input \
                  --rawfile current "$booted_triggers" \
                  --rawfile newgen "$new_triggers" \
                '
                  $current | try fromjson catch {} as $old |
                  $newgen | try fromjson catch {} as $new |
                  $old |
                  to_entries |
                  map(
                    select(.key | in ($new)) |
                    select(.value != $new.[.key]) |
                    [ .key, ":", .value, "->", $new.[.key] ] | join(" ")
                  ) |
                  join("\n")
                ' \
              )"

              ${lib.optionalString (cfg.operation == "switch") # bash
                ''
                  echo "Running switch-to-configuration check..."
                  if "$switch_to_new_configuration" check; then
                    echo "Checking reboot triggers..."
                    if [ -z "$diff" ]; then
                      echo "Switching into the new generation..."
                      "$switch_to_new_configuration" ${cfg.operation}
                      exit 0
                    fi
                  fi
                ''
              }
              ${lib.optionalString (cfg.rebootWindow != null) # bash
                ''
                  if [ "''${do_reboot}" != true ]; then
                    echo "Outside of configured reboot window, skipping."
                    exit 0
                  fi
                ''
              }
              echo "Scheduling a reboot to activate the new generation"
              systemctl reboot --when="+2min"
            ''
          else
            # bash
            ''
              nixos-rebuild ${cfg.operation} ${toString (cfg.flags ++ upgradeFlag)}
            '';

        startAt = cfg.dates;

        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
      };

      systemd.timers.nixos-upgrade = {
        timerConfig = {
          RandomizedDelaySec = cfg.randomizedDelaySec;
          FixedRandomDelay = cfg.fixedRandomDelay;
          Persistent = cfg.persistent;
        };
      };
    })

  ];
}
