{ config, lib, pkgs, utils, ... }:
let
  cfg = config.services.logrotate;

  generateLine = n: v:
    if builtins.elem n [ "files" "priority" "enable" "global" ] || v == null then null
    else if builtins.elem n [ "frequency" ] then "${v}\n"
    else if builtins.elem n [ "firstaction" "lastaction" "prerotate" "postrotate" "preremove" ]
         then "${n}\n    ${v}\n  endscript\n"
    else if lib.isInt v then "${n} ${toString v}\n"
    else if v == true then "${n}\n"
    else if v == false then "no${n}\n"
    else "${n} ${v}\n";
  generateSection = indent: settings: lib.concatStringsSep (lib.fixedWidthString indent " " "") (
    lib.filter (x: x != null) (lib.mapAttrsToList generateLine settings)
  );

  # generateSection includes a final newline hence weird closing brace
  mkConf = settings:
    if settings.global or false then generateSection 0 settings
    else ''
      ${lib.concatMapStringsSep "\n" (files: ''"${files}"'') (lib.toList settings.files)} {
        ${generateSection 2 settings}}
    '';

  settings = lib.sortProperties (lib.attrValues (lib.filterAttrs (_: settings: settings.enable) (
    lib.foldAttrs lib.recursiveUpdate { } [
      {
        header = {
          enable = true;
          missingok = true;
          notifempty = true;
          frequency = "weekly";
          rotate = 4;
        };
      }
      cfg.settings
      { header = { global = true; priority = 100; }; }
    ]
  )));
  configFile = pkgs.writeTextFile {
    name = "logrotate.conf";
    text = lib.concatStringsSep "\n" (
      map mkConf settings
    );
    checkPhase = lib.optionalString cfg.checkConfig ''
      # logrotate --debug also checks that users specified in config
      # file exist, but we only have sandboxed users here so brown these
      # out. according to man page that means su, create and createolddir.
      # files required to exist also won't be present, so missingok is forced.
      user=$(${pkgs.buildPackages.coreutils}/bin/id -un)
      group=$(${pkgs.buildPackages.coreutils}/bin/id -gn)
      sed -e "s/\bsu\s.*/su $user $group/" \
          -e "s/\b\(create\s\+[0-9]*\s*\|createolddir\s\+[0-9]*\s\+\).*/\1$user $group/" \
          -e "1imissingok" -e "s/\bnomissingok\b//" \
          $out > logrotate.conf
      # Since this makes for very verbose builds only show real error.
      # There is no way to control log level, but logrotate hardcodes
      # 'error:' at common log level, so we can use grep, taking care
      # to keep error codes
      set -o pipefail
      if ! ${pkgs.buildPackages.logrotate}/sbin/logrotate -s logrotate.status \
                      --debug logrotate.conf 2>&1 \
                  | ( ! grep "error:" ) > logrotate-error; then
              echo "Logrotate configuration check failed."
              echo "The failing configuration (after adjustments to pass tests in sandbox) was:"
              printf "%s\n" "-------"
              cat logrotate.conf
              printf "%s\n" "-------"
              echo "The error reported by logrotate was as follow:"
              printf "%s\n" "-------"
              cat logrotate-error
              printf "%s\n" "-------"
              echo "You can disable this check with services.logrotate.checkConfig = false,"
              echo "but if you think it should work please report this failure along with"
              echo "the config file being tested!"
              false
      fi
    '';
  };

  mailOption =
    lib.optionalString (lib.foldr (n: a: a || (n.mail or false) != false) false (lib.attrValues cfg.settings))
    "--mail=${pkgs.mailutils}/bin/mail";
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "logrotate" "config" ] "Modify services.logrotate.settings.header instead")
    (lib.mkRemovedOptionModule [ "services" "logrotate" "extraConfig" ] "Modify services.logrotate.settings.header instead")
    (lib.mkRemovedOptionModule [ "services" "logrotate" "paths" ] "Add attributes to services.logrotate.settings instead")
  ];

  options = {
    services.logrotate = {
      enable = lib.mkEnableOption "the logrotate systemd service" // {
        default = lib.foldr (n: a: a || n.enable) false (lib.attrValues cfg.settings);
        defaultText = lib.literalExpression "cfg.settings != {}";
      };

      allowNetworking = lib.mkEnableOption "network access for logrotate";

      settings = lib.mkOption {
        default = { };
        description = ''
          logrotate freeform settings: each attribute here will define its own section,
          ordered by {option}`services.logrotate.settings.<name>.priority`,
          which can either define files to rotate with their settings
          or settings common to all further files settings.
          All attribute names not explicitly defined as sub-options here are passed through
          as logrotate config directives,
          refer to <https://linux.die.net/man/8/logrotate> for details.
        '';
        example = lib.literalExpression ''
          {
            # global options
            header = {
              dateext = true;
            };
            # example custom files
            "/var/log/mylog.log" = {
              frequency = "daily";
              rotate = 3;
            };
            "multiple paths" = {
               files = [
                "/var/log/first*.log"
                "/var/log/second.log"
              ];
            };
            # specify custom order of sections
            "/var/log/myservice/*.log" = {
              # ensure lower priority
              priority = 110;
              postrotate = '''
                systemctl reload myservice
              ''';
            };
          };
          '';
        type = lib.types.attrsOf (lib.types.submodule ({ name, ... }: {
          freeformType = with lib.types; attrsOf (nullOr (oneOf [ int bool str ]));

          options = {
            enable = lib.mkEnableOption "setting individual kill switch" // {
              default = true;
            };

            global = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = ''
                Whether this setting is a global option or not: set to have these
                settings apply to all files settings with a higher priority.
              '';
            };
            files = lib.mkOption {
              type = with lib.types; either str (listOf str);
              default = name;
              defaultText = ''
                The attrset name if not specified
              '';
              description = ''
                Single or list of files for which rules are defined.
                The files are quoted with double-quotes in logrotate configuration,
                so globs and spaces are supported.
                Note this setting is ignored if globals is true.
              '';
            };

            frequency = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = null;
              description = ''
                How often to rotate the logs. Defaults to previously set global setting,
                which itself defaults to weekly.
              '';
            };

            priority = lib.mkOption {
              type = lib.types.int;
              default = 1000;
              description = ''
                Order of this logrotate block in relation to the others. The semantics are
                the same as with `lib.mkOrder`. Smaller values are inserted first.
              '';
            };
          };

        }));
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = configFile;
        defaultText = ''
          A configuration file automatically generated by NixOS.
        '';
        description = ''
          Override the configuration file used by logrotate. By default,
          NixOS generates one automatically from [](#opt-services.logrotate.settings).
        '';
        example = lib.literalExpression ''
          pkgs.writeText "logrotate.conf" '''
            missingok
            "/var/log/*.log" {
              rotate 4
              weekly
            }
          ''';
        '';
      };

      checkConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether the config should be checked at build time.

          Some options are not checkable at build time because of the build sandbox:
          for example, the test does not know about existing files and system users are
          not known.
          These limitations mean we must adjust the file for tests (missingok is forced
          and users are replaced by dummy users), so tests are complemented by a
          logrotate-checkconf service that is enabled by default.
          This extra check can be disabled by disabling it at the systemd level with the
          {option}`systemd.services.logrotate-checkconf.enable` option.

          Conversely there are still things that might make this check fail incorrectly
          (e.g. a file path where we don't have access to intermediate directories):
          in this case you can disable the failing check with this option.
        '';
      };

      extraArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [];
        description = "Additional command line arguments to pass on logrotate invocation";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.logrotate = {
      description = "Logrotate Service";
      documentation = [
        "man:logrotate(8)"
        "man:logrotate(5)"
      ];
      startAt = "hourly";

      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${lib.getExe pkgs.logrotate} ${utils.escapeSystemdExecArgs cfg.extraArgs} ${mailOption} ${cfg.configFile}";

        # performance
        Nice = 19;
        IOSchedulingClass = "best-effort";
        IOSchedulingPriority = 7;

        # hardening
        CapabilityBoundingSet = [
          "CAP_CHOWN"
          "CAP_SETGID"
        ];
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "full";
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged @resources"
          "@chown"
        ];
        UMask = "0027";
      } // lib.optionalAttrs (!cfg.allowNetworking) {
        PrivateNetwork = true;
        RestrictAddressFamilies = "none";
      };
    };
    systemd.services.logrotate-checkconf = {
      description = "Logrotate configuration check";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.logrotate}/sbin/logrotate ${utils.escapeSystemdExecArgs cfg.extraArgs} --debug ${cfg.configFile}";
      };
    };
  };
}
