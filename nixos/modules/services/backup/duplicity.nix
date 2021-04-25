{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.duplicity;

  stateDirectory = "/var/lib/duplicity";

  localTarget =
    if hasPrefix "file://" cfg.targetUrl
    then removePrefix "file://" cfg.targetUrl else null;

in
{
  options.services.duplicity = {
    enable = mkEnableOption "backups with duplicity";

    root = mkOption {
      type = types.path;
      default = "/";
      description = ''
        Root directory to backup.
      '';
    };

    include = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "/home" ];
      description = ''
        List of paths to include into the backups. See the FILE SELECTION
        section in <citerefentry><refentrytitle>duplicity</refentrytitle>
        <manvolnum>1</manvolnum></citerefentry> for details on the syntax.
      '';
    };

    exclude = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of paths to exclude from backups. See the FILE SELECTION section in
        <citerefentry><refentrytitle>duplicity</refentrytitle>
        <manvolnum>1</manvolnum></citerefentry> for details on the syntax.
      '';
    };

    targetUrl = mkOption {
      type = types.str;
      example = "s3://host:port/prefix";
      description = ''
        Target url to backup to. See the URL FORMAT section in
        <citerefentry><refentrytitle>duplicity</refentrytitle>
        <manvolnum>1</manvolnum></citerefentry> for supported urls.
      '';
    };

    secretFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path of a file containing secrets (gpg passphrase, access key...) in
        the format of EnvironmentFile as described by
        <citerefentry><refentrytitle>systemd.exec</refentrytitle>
        <manvolnum>5</manvolnum></citerefentry>. For example:
        <programlisting>
        PASSPHRASE=<replaceable>...</replaceable>
        AWS_ACCESS_KEY_ID=<replaceable>...</replaceable>
        AWS_SECRET_ACCESS_KEY=<replaceable>...</replaceable>
        </programlisting>
      '';
    };

    frequency = mkOption {
      type = types.nullOr types.str;
      default = "daily";
      description = ''
        Run duplicity with the given frequency (see
        <citerefentry><refentrytitle>systemd.time</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry> for the format).
        If null, do not run automatically.
      '';
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "--full-if-older-than" "1M" ];
      description = ''
        Extra command-line flags passed to duplicity. See
        <citerefentry><refentrytitle>duplicity</refentrytitle>
        <manvolnum>1</manvolnum></citerefentry>.
      '';
    };

    cleanup = {
      maxAge = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "6M";
        description = ''
          If non-null, delete all backup sets older than the given time.  Old backup sets
          will not be deleted if backup sets newer than time depend on them.
        '';
      };
      maxFull = mkOption {
        type = types.nullOr types.int;
        default = null;
        example = 2;
        description = ''
          If non-null, delete all backups sets that are older than the count:th last full
          backup (in other words, keep the last count full backups and
          associated incremental sets).
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd = {
      services.duplicity = {
        description = "backup files with duplicity";

        environment.HOME = stateDirectory;

        script =
          let
            target = escapeShellArg cfg.targetUrl;
            extra = escapeShellArgs ([ "--archive-dir" stateDirectory ] ++ cfg.extraFlags);
            dup = "${pkgs.duplicity}/bin/duplicity";
          in
          ''
            set -x
            ${dup} cleanup ${target} --force ${extra}
            ${lib.optionalString (cfg.cleanup.maxAge != null) "${dup} remove-older-than ${lib.escapeShellArg cfg.cleanup.maxAge} ${target} --force ${extra}"}
            ${lib.optionalString (cfg.cleanup.maxFull != null) "${dup} remove-all-but-n-full ${toString cfg.cleanup.maxFull} ${target} --force ${extra}"}
            exec ${dup} incr ${lib.escapeShellArgs (
              [ cfg.root cfg.targetUrl ]
              ++ concatMap (p: [ "--include" p ]) cfg.include
              ++ concatMap (p: [ "--exclude" p ]) cfg.exclude
              )} ${extra}
          '';
        serviceConfig = {
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = "read-only";
          StateDirectory = baseNameOf stateDirectory;
        } // optionalAttrs (localTarget != null) {
          ReadWritePaths = localTarget;
        } // optionalAttrs (cfg.secretFile != null) {
          EnvironmentFile = cfg.secretFile;
        };
      } // optionalAttrs (cfg.frequency != null) {
        startAt = cfg.frequency;
      };

      tmpfiles.rules = optional (localTarget != null) "d ${localTarget} 0700 root root -";
    };

    assertions = singleton {
      # Duplicity will fail if the last file selection option is an include. It
      # is not always possible to detect but this simple case can be caught.
      assertion = cfg.include != [ ] -> cfg.exclude != [ ] || cfg.extraFlags != [ ];
      message = ''
        Duplicity will fail if you only specify included paths ("Because the
        default is to include all files, the expression is redundant. Exiting
        because this probably isn't what you meant.")
      '';
    };
  };
}
