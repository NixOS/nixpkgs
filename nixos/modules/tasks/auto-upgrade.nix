{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}:
let
  cfg = config.system.autoUpgrade;
  nixpkgs-cfg = config.nixpkgs;
  nixos-rebuild = lib.getExe config.system.build.nixos-rebuild;
  upgradeFlag = if cfg.upgradeAll then "--upgrade-all" else "--upgrade";
  upgradeScript =
    flags:
    pkgs.writeShellScript "upgrade-channels" ''
      set -euo pipefail

      # Upgrade the channels if required, without spending any time building
      ${nixos-rebuild} list-generations ${upgradeFlag} ${toString flags}

      ${lib.optionalString (cfg.desync != { }) ''
        # Upgrade the desync files
        exec ${upgradeDesyncsPkg}/bin/nixos-upgrade-desyncs
      ''}
    '';
  desyncFile = desyncId: "/var/lib/nixos/desyncs/${lib.strings.escapeShellArg desyncId}.nix";
  upgradeDesyncsPkg = pkgs.writeShellScriptBin "nixos-upgrade-desyncs" ''
    set -euo pipefail

    mkdir -p /var/lib/nixos/desyncs

    # Generate the new files

    ${lib.concatMapStrings (
      desyncId:
      let
        file = desyncFile desyncId;
      in
      ''

        echo "Trying to upgrade ${file}"
        # There is no overlay nor configuration in the imports below.
        # This is expected, as it evaluates the nixos configuration in exactly
        # the same way as `nixos-rebuild` would have.
        cp -df ${file} ${file}.old || true
        ${lib.getExe' config.nix.package "nix-build"} \
          -E '(import <nixpkgs/nixos> {})
          .config.system.autoUpgrade.desync
          .'${lib.strings.escapeShellArg (lib.strings.escapeNixString desyncId)}'.desyncUpgradeScript' \
          --out-link ${file} \
          || \
        ${lib.getExe' config.nix.package "nix-build"} \
          -E '(import <nixpkgs/nixos> {})
          .config.system.autoUpgrade.desync
          .'${lib.strings.escapeShellArg (lib.strings.escapeNixString desyncId)}'.upgradeFailedScript' \
          --out-link ${file}
      ''
    ) (lib.attrNames cfg.desync)}

    # Check that the system configuration still builds properly
    if ${nixos-rebuild} build ${toString cfg.flags}; then
      build_succeeded="true"
    else
      build_succeeded="false"
    fi

    # Either clean up the .old files, or recover from them
    if [ "$build_succeeded" != "true" ]; then
      cleanup() {
        mv "$1.old" "$1"
      }
    else
      cleanup() {
        rm -f "$1.old"
      }
    fi

    ${lib.concatMapStringsSep "\n" (file: "cleanup ${desyncFile file}") (lib.attrNames cfg.desync)}
  '';
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
        example = "https://nixos.org/channels/nixos-14.12-small";
        description = ''
          The URI of the NixOS channel to use for automatic
          upgrades. By default, this is the channel set using
          {command}`nix-channel` (run `nix-channel --list`
          to see the current value).
        '';
      };

      upgradeAll = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to pass `--upgrade-all` or `--upgrade` to `nixos-rebuild` when
          upgrading the channels.
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

      desync = lib.mkOption {
        default = { };
        description = ''
          A set of nixpkgs copies that can be updated independently of the main nixpkgs.

          It allows the system to keep building even if the latest version of the channel
          has a broken build for a package.

          If it is used, then the `nixos-upgrade-desyncs` command is added to the system
          environment, that can be used to try to upgrade the desyncs to the current channel
          version.
          If they build fine then they will be upgraded, if not they will be left at their
          current setting.

          Using `maxDesyncAge`, you can limit the number of rebuilds that one nixpkgs
          version is allowed to span.
          For example, if you have `system.autoUpgrade` set to upgrade once a day, and
          `maxDesyncAge` set to `14` (the default), then your packages will always be on
          a version of `nixpkgs` that is at most two weeks old.
          If no such version has a passing build for one week, then the `mixos-rebuild`
          service will still fail.

          Finally, note that overlays are not taken into account inside desyncs. This is
          because, otherwise, evaluation would enter infinite loops.
          If you need to overlay your desyncs, you can use the `desync.*.overlays` option.

          For example, you can use this module this way, in order to get your system to
          auto-upgrade even if `matrix-synapse` does not build on the latest channel:
          ```nix
          {
            system.autoUpgrade.desync.for-synapse = {
              requireBuilds = pkgs: [ pkgs.matrix-synapse ];
            };

            containers.matrix-synapse = {
              autoStart = true;
              nixpkgs = config.system.autoUpgrade.desync.for-synapse.path;
              config = {
                services.matrix-synapse = {
                  # ...
                };
              };
            };
          }
          ```

          Note that you should be careful about where you use the desync: by using it you no
          longer have a single nixpkgs evaluation, and mix-and-matching packages could lead
          to unexpected results.
          Most of the time, you should likely use one full container for each desync, this
          way each nixos evaluation will be with a consistent set of packages.
        '';

        type = lib.types.attrsOf (
          lib.types.submodule (
            { config, name, ... }:
            {
              # Options for the end-user for configuring
              options.defaultPath = lib.mkOption {
                default = modulesPath + "/../..";
                defaultText = lib.literalMD "Path of the nixpkgs evaluation the auto-upgrade module is part of";
                description = "Default path to use for the nixpkgs";
                type = lib.types.path;
              };

              options.overlays = lib.mkOption {
                default = [ ];
                description = "Overlays to add to the nixpkgs evaluation for this desync";
                type = lib.types.listOf lib.types.extensionFunction;
              };

              options.pkgsFor = lib.mkOption {
                default =
                  path:
                  import path {
                    inherit (nixpkgs-cfg) config localSystem crossSystem;
                    overlays = config.overlays;
                  };
                defaultText = lib.literalExpression ''
                  # Reuse the top-level nixpkgs configuration, except for overlays that would cause
                  # an infinite loop if a package from a desync were to be used in an overlay.
                  path: import path {
                    inherit (nixpkgs-cfg) config localSystem crossSystem;
                    overlays = config.system.autoUpgrade.desync.<name>.overlays;
                  }
                '';
                description = ''
                  The nixpkgs package set to attempt using.
                  It gets passed the path to the nixpkgs under test.

                  If the required builds pass with it, then the current nixpkgs will be saved
                  as a working version of nixpkgs.
                  If the required builds do not pass with it, then the current build will be
                  done with the last known working path of nixpkgs, still using this function.
                '';
                type = lib.types.functionTo lib.types.pkgs;
              };

              options.requireBuilds = lib.mkOption {
                example = lib.literalExpression "pkgs: with pkgs; [ home-assistant matrix-synapse ]";
                description = ''
                  The builds that must pass to consider this version of nixpkgs a working version.

                  If these builds do not pass, the last known working version of nixpkgs will be
                  used for it.
                '';
                type = lib.types.functionTo (lib.types.listOf lib.types.package);
              };

              options.maxDesyncAge = lib.mkOption {
                default = 14;
                description = ''
                  Maximum number of rebuilds and switches that a specific nixpkgs version can stay alive.

                  No limit if set to `null`.

                  This defaults to `14` in order to avoid packages silently becoming infinitely old with
                  this module simply enabled.
                '';
                type = lib.types.nullOr lib.types.ints.positive;
              };

              # Read-only options, defined here and for consumption by the end-user
              options.desyncAge = lib.mkOption {
                readOnly = true;
                description = ''
                  The age (in number of rebuilds) of this nixpkgs version.
                '';
                type = lib.types.ints.unsigned;
              };

              options.path = lib.mkOption {
                readOnly = true;
                description = ''
                  The path to the last known-working version of nixpkgs that passes all
                  `requireBuilds`.

                  This option is read-only, and is the result of this package.
                '';
                type = lib.types.path;
              };

              options.pkgs = lib.mkOption {
                readOnly = true;
                description = ''
                  The last known-working version of nixpkgs that passes all `requireBuilds`.

                  This option is read-only, and is the result of this package.
                '';
                type = lib.types.pkgs;
              };

              # Internal options and configuration, to make this work
              options.desyncUpgradeScript = lib.mkOption {
                # Derivation called to upgrade the desync files.
                # `$out` will be symlinked from `/var/lib/nixos/desyncs/${name}.nix by the `upgradeScript`
                readOnly = true;
                internal = true;
                visible = false;
                description = ''
                  Derivation called to upgrade the desync files.
                  `$out` will be symlinked from `/var/lib/nixos/desyncs/${name}.nix by the `upgradeScript`
                '';
                type = lib.types.package;
              };

              options.upgradeFailedScript = lib.mkOption {
                # Derivation called when the latest upgrade failed.
                # `$out` will be symlinked from `/var/lib/nixos/desyncs/${name}.nix by the `upgradeScript`
                readOnly = true;
                internal = true;
                visible = false;
                description = ''
                  Derivation called when the latest upgrade failed.
                  `$out` will be symlinked from `/var/lib/nixos/desyncs/${name}.nix by the `upgradeScript`
                '';
                type = lib.types.package;
              };

              config =
                let
                  desync =
                    if builtins.pathExists /var/lib/nixos/desyncs/${name}.nix then
                      import /var/lib/nixos/desyncs/${name}.nix
                    else
                      {
                        # If we have no desync saved, it means that any configuration that builds
                        # would necessarily be with the default path.
                        # This can happen eg. on the `nixos-rebuild` that adds the desync configuration
                        # to a nixos config, that would most likely not happen during an auto-upgrade.
                        desyncAge = 0;
                        path = config.defaultPath;
                      };
                in
                {
                  inherit (desync) desyncAge path;
                  pkgs = config.pkgsFor desync.path;

                  desyncUpgradeScript = pkgs.runCommand "nixos-desync-${name}" { } ''
                    #!/bin/sh
                    set -euo pipefail

                    # Force dependencies on `requireBuilds`
                    # ${lib.concatStringsSep " " (config.requireBuilds (config.pkgsFor (config.defaultPath)))}

                    # Write the result in `$out` if this passed
                    cat - > "$out" <<EOF
                    {
                      desyncAge = 0;
                      path = builtins.toPath ${
                        # Convert the now-validated path into an absolute path in the store, then into a string
                        lib.strings.escapeNixString (builtins.path { path = config.defaultPath; })
                      };
                    }
                    EOF
                  '';

                  upgradeFailedScript = pkgs.runCommand "nixos-upgrade-failed-${name}" { } ''
                    #!/bin/sh
                    set -euo pipefail

                    ${lib.optionalString (config.desyncAge >= config.maxDesyncAge) ''
                      echo "Did not get any successful build for ${name} in the past ${toString config.desyncAge} rebuilds!" >&2
                      exit 1
                    ''}

                    if readlink -f ${lib.strings.escapeShellArg config.path} | grep -E '^/nix/store/'; then
                      # Write the result in `$out` if this passed
                      cat - > "$out" <<EOF
                    {
                      desyncAge = ${toString (config.desyncAge + 1)};
                      path = builtins.toPath ${lib.strings.escapeNixString config.path};
                    }
                    EOF
                    else
                      echo "No known-good desync version, please rollback to a channel that builds fine and retry" >&2
                      exit 1
                    fi
                  '';
                };
            }
          )
        );
      };

    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion = !((cfg.channel != null) && (cfg.flake != null));
        message = ''
          The options 'system.autoUpgrade.channel' and 'system.autoUpgrade.flake' cannot both be set.
        '';
      }
    ];

    environment.systemPackages = lib.optional (cfg.desync != { }) upgradeDesyncsPkg;

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
        xz.bin
        gzip
        gitMinimal
        config.nix.package.out
        config.programs.ssh.package
      ];

      script =
        let
          date = "${pkgs.coreutils}/bin/date";
          readlink = "${pkgs.coreutils}/bin/readlink";
          shutdown = "${config.systemd.package}/bin/shutdown";
          maybeUpgradeScript = flags: lib.optionalString (cfg.channel == null) (upgradeScript flags);
        in
        if cfg.allowReboot then
          ''
            ${maybeUpgradeScript cfg.flags}

            ${nixos-rebuild} boot ${toString cfg.flags}
            booted="$(${readlink} /run/booted-system/{initrd,kernel,kernel-modules})"
            built="$(${readlink} /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

            ${lib.optionalString (cfg.rebootWindow != null) ''
              current_time="$(${date} +%H:%M)"

              lower="${cfg.rebootWindow.lower}"
              upper="${cfg.rebootWindow.upper}"

              if [[ "''${lower}" < "''${upper}" ]]; then
                if [[ "''${current_time}" > "''${lower}" ]] && \
                   [[ "''${current_time}" < "''${upper}" ]]; then
                  do_reboot="true"
                else
                  do_reboot="false"
                fi
              else
                # lower > upper, so we are crossing midnight (e.g. lower=23h, upper=6h)
                # we want to reboot if cur > 23h or cur < 6h
                if [[ "''${current_time}" < "''${upper}" ]] || \
                   [[ "''${current_time}" > "''${lower}" ]]; then
                  do_reboot="true"
                else
                  do_reboot="false"
                fi
              fi
            ''}

            if [ "''${booted}" = "''${built}" ]; then
              ${nixos-rebuild} ${cfg.operation} ${toString cfg.flags}
            ${lib.optionalString (cfg.rebootWindow != null) ''
              elif [ "''${do_reboot}" != true ]; then
                echo "Outside of configured reboot window, skipping."
            ''}
            else
              ${shutdown} -r +1
            fi
          ''
        else
          ''
            ${maybeUpgradeScript cfg.flags}

            ${nixos-rebuild} ${cfg.operation} ${toString cfg.flags}
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
  };

}
