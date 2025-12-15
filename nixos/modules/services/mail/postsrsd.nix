{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let

  cfg = config.services.postsrsd;

  inherit (lib)
    concatMapStringsSep
    concatMapAttrsStringSep
    isBool
    isFloat
    isInt
    isPath
    isString
    isList
    mkEnableOption
    mkPackageOption
    mkRemovedOptionModule
    mkRenamedOptionModule
    ;

  # This is a implementation of a simple libconfuse config renderer sufficient
  # for the postsrsd configuration file complexity.
  # TODO: Replace with pkgs.formats.libconfuse, once implemented (https://github.com/NixOS/nixpkgs/issues/401565)
  renderValue =
    value:
    if isBool value then
      if value then "true" else "false"
    else if isString value || isPath value then
      builtins.toJSON value # for escaping
    else if isInt value || isFloat value then
      toString value
    else if isList value then
      "{${concatMapStringsSep "," renderValue value}}"
    else
      throw "postsrsd: unsupported value type in settings option";

  renderAttr =
    attrs: concatMapAttrsStringSep "\n" (name: value: "${name} = ${renderValue value}") attrs;

  configFile = pkgs.writeText "postsrsd.conf" (
    renderAttr (lib.filterAttrsRecursive (_: v: v != null) cfg.settings)
  );
in
{
  imports = [
    (mkRemovedOptionModule [ "services" "postsrsd" "socketPath" ] ''
      Configure/reference `services.postsrsd.settings.socketmap` instead. Note that its now required to start with the `inet:` or `unix:` prefix.
    '')
    (mkRenamedOptionModule
      [ "services" "postsrsd" "domains" ]
      [ "services" "postsrsd" "settings" "domains" ]
    )
    (mkRenamedOptionModule
      [ "services" "postsrsd" "separator" ]
      [ "services" "postsrsd" "settings" "separator" ]
    )
  ]
  ++
    map
      (
        name:
        lib.mkRemovedOptionModule [ "services" "postsrsd" name ] ''
          `postsrsd` was upgraded to `>= 2.0.0`, with some different behaviors and configuration settings:
            - NixOS Release Notes: https://nixos.org/manual/nixos/unstable/release-notes#sec-nixpkgs-release-25.05-incompatibilities
            - NixOS Options Reference: https://nixos.org/manual/nixos/unstable/options#opt-services.postsrsd.enable
            - Migration instructions: https://github.com/roehling/postsrsd/blob/2.0.10/README.rst#migrating-from-version-1x
            - Postfix Setup: https://github.com/roehling/postsrsd/blob/2.0.10/README.rst#postfix-setup
        ''
      )
      [
        "domain"
        "forwardPort"
        "reversePort"
        "timeout"
        "excludeDomains"
      ];

  options = {
    services.postsrsd = {
      enable = mkEnableOption "the postsrsd SRS server for Postfix.";

      package = mkPackageOption pkgs "postsrsd" { };

      secretsFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/postsrsd/postsrsd.secret";
        description = ''
          Secret keys used for signing and verification.

          ::: {.note}
          The secret will be generated, if it does not exist at the given path.
          :::
        '';
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType =
            with lib.types;
            attrsOf (oneOf [
              bool
              float
              int
              path
              str
              (listOf str)
            ]);

          options = {
            domains = lib.mkOption {
              type = with lib.types; listOf str;
              default = [ ];
              example = [ "example.com" ];
              description = ''
                List of local domains, that do not require rewriting.
              '';
            };

            secrets-file = lib.mkOption {
              type = lib.types.str;
              default = "\${CREDENTIALS_DIRECTORY}/secrets-file";
              readOnly = true;
              description = ''
                Path to the file containing the secret keys.

                ::: {.note}
                Secrets are passed using `LoadCredential=` on the systemd unit,
                so this options is read-only.

                Configure {option}`services.postsrsd.secretsFile` instead.
              '';
            };

            separator = lib.mkOption {
              type = lib.types.enum [
                "-"
                "="
                "+"
              ];
              default = "=";
              description = ''
                SRS tag separator used in generated sender addresses.

                Unless you have a very good reason, you should leave this
                setting at its default.
              '';
            };

            srs-domain = lib.mkOption {
              type = with lib.types; nullOr str;
              default = null;
              example = "srs.example.com";
              description = ''
                Dedicated mail domain used for ephemeral SRS envelope addresses.

                Recommended to configure, when hosting multiple unrelated mail
                domains (e.g. for different customers), to prevent privacy
                issues.

                Set to `null` to not configure any `srs-domain`.
              '';
            };

            socketmap = lib.mkOption {
              type = lib.types.strMatching "^(unix|inet):.+";
              default = "unix:/run/postsrsd/socket";
              example = "inet:localhost:10003";
              description = ''
                Listener configuration in socket map format native to Postfix configuration.
              '';
            };

            chroot-dir = lib.mkOption {
              type = lib.types.str;
              default = "";
              readOnly = true;
              description = ''
                Path to chroot into at runtime as an additional layer of protection.

                ::: {.note}
                We confine the runtime environment through systemd hardening instead, so this option is read-only.
                :::
              '';
            };

            unprivileged-user = lib.mkOption {
              type = lib.types.str;
              default = "";
              readOnly = true;
              description = ''
                Unprivileged user to drop privileges to.

                ::: {.note}
                Our systemd unit never runs postsrsd as a privileged process, so this option is read-only.
                :::
              '';
            };
          };
        };
        default = { };
        description = ''
          Configuration options for the postsrsd.conf file.

          See the [example configuration](https://github.com/roehling/postsrsd/blob/${cfg.package.version}/doc/postsrsd.conf) for possible values.
        '';
      };

      configurePostfix = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to configure the required settings to use postsrsd in the local Postfix instance.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "postsrsd";
        description = "User for the daemon";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "postsrsd";
        description = "Group for the daemon";
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && cfg.configurePostfix && config.services.postfix.enable) {
      services.postfix.settings.main = {
        # https://github.com/roehling/postsrsd#configuration
        sender_canonical_maps = "socketmap:${cfg.settings.socketmap}:forward";
        sender_canonical_classes = "envelope_sender";
        recipient_canonical_maps = "socketmap:${cfg.settings.socketmap}:reverse";
        recipient_canonical_classes = [
          "envelope_recipient"
          "header_recipient"
        ];
      };

      users.users.postfix.extraGroups = [ cfg.group ];
    })

    (lib.mkIf cfg.enable {
      users.users = lib.optionalAttrs (cfg.user == "postsrsd") {
        postsrsd = {
          group = cfg.group;
          uid = config.ids.uids.postsrsd;
        };
      };

      users.groups = lib.optionalAttrs (cfg.group == "postsrsd") {
        postsrsd.gid = config.ids.gids.postsrsd;
      };

      systemd.services.postsrsd-generate-secrets = {
        path = [ pkgs.coreutils ];
        script = ''
          if [ -e "${cfg.secretsFile}" ]; then
            echo "Secrets file exists. Nothing to do!"
          else
            echo "WARNING: secrets file not found, autogenerating!"
            DIR="$(dirname "${cfg.secretsFile}")"
            install -m 750 -o ${cfg.user} -g ${cfg.group} -d "$DIR"
            install -m 600 -o ${cfg.user} -g ${cfg.group} <(dd if=/dev/random bs=18 count=1 | base64) "${cfg.secretsFile}"
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
        };
      };

      environment.etc."postsrsd.conf".source = configFile;

      systemd.services.postsrsd = {
        description = "PostSRSd SRS rewriting server";
        after = [
          "network.target"
          "postsrsd-generate-secrets.service"
        ];
        before = [ "postfix.service" ];
        wantedBy = [ "multi-user.target" ];
        requires = [ "postsrsd-generate-secrets.service" ];
        restartTriggers = [ configFile ];

        serviceConfig = {
          ExecStart = utils.escapeSystemdExecArgs [
            (lib.getExe cfg.package)
            "-C"
            "/etc/postsrsd.conf"
          ];
          User = cfg.user;
          Group = cfg.group;
          RuntimeDirectory = "postsrsd";
          RuntimeDirectoryMode = "0750";
          LoadCredential = "secrets-file:${cfg.secretsFile}";

          CapabilityBoundingSet = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateMounts = true;
          PrivateNetwork = lib.hasPrefix "unix:" cfg.settings.socketmap;
          PrivateTmp = true;
          PrivateUsers = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          RemoveIPC = true;
          RestrictAddressFamilies =
            if lib.hasPrefix "unix:" cfg.settings.socketmap then
              [ "AF_UNIX" ]
            else
              [
                "AF_INET"
                "AF_INET6"
              ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged @resources"
          ];
          UMask = "0027";
        };
      };
    })
  ];

  # package version referenced in option documentation
  meta.buildDocsInSandbox = false;
}
