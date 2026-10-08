{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.tlog;
  settingsFormat = pkgs.formats.json { };

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
    else
      conf;

  settingsOption =
    prog: extraOptions:
    lib.mkOption {
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = extraOptions;
      };
      default = { };
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

    settings = {
      "rec" = settingsOption "rec" { };
      rec-session = settingsOption "rec-session" {
        shell = lib.mkOption {
          type = lib.types.either lib.types.shellPackage lib.types.path;
          # Upstream defaults to /bin/bash, which does not exist on NixOS.
          default = "/run/current-system/sw/bin/bash";
          example = lib.literalExpression "pkgs.zsh";
          # A package would otherwise serialize to its store directory.
          apply = shell: if lib.isDerivation shell then lib.getExe shell else shell;
          description = "Shell that {command}`tlog-rec-session` spawns and records.";
        };
      };
      play = settingsOption "play" { };
    };
  };

  config = lib.mkIf cfg.enable {
    # tlog-rec and tlog-play are the admin-facing tools (ad-hoc recording,
    # replaying sessions from the journal).
    environment.systemPackages = [ cfg.package ];
    environment.shells = [ "${config.security.wrapperDir}/tlog-rec-session" ];

    # The binaries refuse to start without these files, so always create them.
    environment.etc = lib.genAttrs' [ "rec" "rec-session" "play" ] (
      prog:
      lib.nameValuePair "tlog/tlog-${prog}.conf" {
        source = validatedConf prog;
      }
    );

    # tlog-rec-session runs setuid/setgid tlog so that the recorded user
    # cannot tamper with the session locks in /run/tlog (which would let
    # them skip recording). It drops back to the user before spawning the
    # shell.
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

    users.users.tlog = {
      isSystemUser = true;
      group = "tlog";
      description = "tlog session recording";
    };
    users.groups.tlog = { };
  };

  meta = {
    doc = ./tlog.md;
    maintainers = with lib.maintainers; [ oakenshield ];
  };
}
