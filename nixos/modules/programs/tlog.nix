{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.tlog;
  settingsFormat = pkgs.formats.json { };
  wrapper = "${config.security.wrapperDir}/tlog-rec-session";

  # tlog rejects unknown keys and wrong types at startup, which for
  # tlog-rec-session means every recorded user is locked out. Catch that at
  # build time by loading the generated file with the real binary: a binary
  # run from a `.libs` directory reads its config from the parent directory.
  validatedConf =
    prog:
    let
      conf = settingsFormat.generate "tlog-${prog}.conf" cfg.settings.${prog};
    in
    if pkgs.stdenv.buildPlatform.canExecute pkgs.stdenv.hostPlatform then
      pkgs.runCommand "tlog-${prog}.conf" { } ''
        mkdir -p check/.libs
        cp ${cfg.package}/bin/tlog-${prog} check/.libs/
        cp ${cfg.package}/share/tlog/tlog-${prog}.default.conf check/
        cp ${conf} check/tlog-${prog}.conf
        check/.libs/tlog-${prog} --version > /dev/null
        cp ${conf} $out
      ''
    # Cross: the binary cannot run on the build platform, so skip the check.
    else
      conf;

  settingsOption =
    prog: example: extraOptions:
    lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = extraOptions;
      };
      default = { };
      inherit example;
      description = ''
        System-wide configuration for {command}`tlog-${prog}`, written to
        {file}`/etc/tlog/tlog-${prog}.conf`. Values here override the
        package defaults. See {manpage}`tlog-${prog}.conf(5)` for the schema.
      '';
    };
in
{
  options.programs.tlog = {
    enable = lib.mkEnableOption "tlog terminal I/O session recording";

    package = lib.mkPackageOption pkgs "tlog" { };

    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "alice" ];
      description = ''
        Users whose sessions are recorded, by their attribute name in
        {option}`users.users` (not their login name). Their login shell is set
        to the {command}`tlog-rec-session` wrapper, which runs
        {option}`programs.tlog.settings.rec-session.shell` for all of them.

        Each user must be declared and enabled in {option}`users.users`; for
        users from a directory such as LDAP or SSSD, set the login shell in the
        directory instead. Setting a listed user's
        {option}`users.users.<name>.shell` elsewhere is an error unless that
        definition has default priority, as {option}`users.defaultUserShell`
        does. Listing `root` makes root's console and SSH
        logins, including the rescue and emergency shells, depend on tlog
        working.
      '';
    };

    settings = {
      "rec" = settingsOption "rec" { writer = "journal"; } { };
      rec-session = settingsOption "rec-session" { log.input = true; } {
        shell = lib.mkOption {
          type = lib.types.either lib.types.shellPackage lib.types.path;
          # Upstream defaults to /bin/bash, which does not exist on NixOS.
          default = "/run/current-system/sw/bin/bash";
          example = lib.literalExpression "pkgs.zsh";
          # A package would otherwise serialize to its store directory. Use
          # shellPath, not lib.getExe: for busybox the shell is ash, not the
          # main program.
          apply = shell: if lib.isDerivation shell then "${shell}${shell.shellPath}" else shell;
          description = "Shell that {command}`tlog-rec-session` spawns and records.";
        };
      };
      play = settingsOption "play" { reader = "journal"; } { };
    };
  };

  config = lib.mkMerge [
    {
      # Outside mkIf: otherwise listed users would silently go unrecorded
      # whenever tlog is disabled, for example by a profile's mkForce.
      warnings =
        lib.optional (!cfg.enable && cfg.users != [ ])
          "programs.tlog.users is set but programs.tlog.enable is false, so ${lib.concatStringsSep ", " cfg.users} will not be recorded.";
    }
    (lib.mkIf cfg.enable {
      # Not caught by the --version check above: tlog only notices a missing
      # path when it opens the log sink, so every recorded login would fail.
      # tlog-rec is exempt: its default writer is "file", with the path passed
      # on the command line.
      assertions = [
        {
          assertion =
            (cfg.settings.rec-session.writer or null) == "file"
            -> (cfg.settings.rec-session.file.path or "") != "";
          message = ''programs.tlog.settings.rec-session.writer = "file" requires file.path.'';
        }
        {
          # Without wrappers the shell of every recorded user points at a file
          # that is never created, locking them out.
          assertion = config.security.enableWrappers;
          message = "programs.tlog requires security.enableWrappers: tlog-rec-session runs as a setuid wrapper.";
        }
        {
          assertion = !lib.elem "tlog" cfg.users;
          message = "programs.tlog.users must not contain tlog, the account tlog-rec-session runs as.";
        }
      ]
      ++ lib.concatMap (
        name:
        let
          user = config.users.users.${name};
        in
        [
          {
            # uid alone counts as declared: that is how NixOS declares root.
            # A disabled account is never created, so its shell is never set.
            assertion = user.enable && (user.isNormalUser || user.isSystemUser || user.uid != null);
            message = "programs.tlog.users contains ${name}, but users.users.${name} is not a declared, enabled account. Entries are users.users attribute names, not login names; set the login shell of directory (LDAP/SSSD) users in the directory instead.";
          }
          {
            # A higher-priority definition (mkForce) would otherwise win silently
            # and leave the user unrecorded.
            assertion = user.shell == wrapper;
            message = "users.users.${name}.shell is overridden elsewhere, so ${name}, listed in programs.tlog.users, would not be recorded.";
          }
        ]
      ) cfg.users;

      # tlog-rec and tlog-play are the admin-facing tools (ad-hoc recording,
      # replaying sessions from the journal).
      environment.systemPackages = [ cfg.package ];
      # The wrapper is deliberately not added to environment.shells: chsh only
      # lets a user change a shell that is listed there, so listing it would let
      # recorded users switch themselves to an unrecorded shell. Upstream dropped
      # it from its RPM for the same reason.

      # The binaries refuse to start without these files, so always create them.
      environment.etc = lib.genAttrs' [ "rec" "rec-session" "play" ] (
        prog:
        lib.nameValuePair "tlog/tlog-${prog}.conf" {
          source = validatedConf prog;
        }
      );

      # tlog-rec-session runs setuid/setgid tlog so that it can create the
      # session locks in /run/tlog, which users cannot write to directly (a
      # pre-created lock would skip recording). It drops back to the user
      # before spawning the shell. This does not fully protect the locks:
      # upstream applies TLOG_REC_SESSION_* environment variables even when
      # setuid, including the file writer's path, which it opens as tlog.
      security.wrappers.tlog-rec-session = {
        source = "${cfg.package}/bin/tlog-rec-session";
        owner = "tlog";
        group = "tlog";
        setuid = true;
        setgid = true;
      };

      # The lock dir compiled into the binaries is /var/run/tlog.
      systemd.tmpfiles.settings.tlog."/run/tlog".d = {
        user = "tlog";
        group = "tlog";
        mode = "0755";
      };

      users.users = lib.mkMerge [
        {
          tlog = {
            isSystemUser = true;
            group = "tlog";
            description = "tlog session recording";
          };
        }
        (lib.genAttrs cfg.users (_: {
          shell = wrapper;
        }))
      ];
      users.groups.tlog = { };
    })
  ];

  meta = {
    doc = ./tlog.md;
    maintainers = with lib.maintainers; [ oakenshield ];
  };
}
