# NixOS module for Buildbot Worker.
{
  config,
  lib,
  options,
  pkgs,
  ...
}:
let
  cfg = config.services.buildbot-worker;
  opt = options.services.buildbot-worker;

  package = pkgs.python3.pkgs.toPythonModule cfg.package;
  python = package.pythonModule;

  tacFile = pkgs.writeText "aur-buildbot-worker.tac" ''
    import os
    from io import open

    from buildbot_worker.bot import Worker
    from twisted.application import service

    basedir = '${cfg.buildbotDir}'

    # note: this line is matched against to check that this is a worker
    # directory; do not edit it.
    application = service.Application('buildbot-worker')

    master_url_split = '${cfg.masterUrl}'.split(':')
    buildmaster_host = master_url_split[0]
    port = int(master_url_split[1])
    workername = '${cfg.workerUser}'

    with open('${cfg.workerPassFile}', 'r', encoding='utf-8') as passwd_file:
        passwd = passwd_file.read().strip('\r\n')
    keepalive = ${toString cfg.keepalive}
    umask = None
    maxdelay = 300
    numcpus = None
    allow_shutdown = None

    s = Worker(buildmaster_host, port, workername, passwd, basedir,
               keepalive, umask=umask, maxdelay=maxdelay,
               numcpus=numcpus, allow_shutdown=allow_shutdown)
    s.setServiceParent(application)
  '';

in
{
  options = {
    services.buildbot-worker = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the Buildbot Worker.";
      };

      user = lib.mkOption {
        default = "bbworker";
        type = lib.types.str;
        description = "User the buildbot Worker should execute under.";
      };

      group = lib.mkOption {
        default = "bbworker";
        type = lib.types.str;
        description = "Primary group of buildbot Worker user.";
      };

      extraGroups = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "List of extra groups that the Buildbot Worker user should be a part of.";
      };

      home = lib.mkOption {
        default = "/home/bbworker";
        type = lib.types.path;
        description = "Buildbot home directory.";
      };

      buildbotDir = lib.mkOption {
        default = "${cfg.home}/worker";
        defaultText = lib.literalExpression ''"''${config.${opt.home}}/worker"'';
        type = lib.types.path;
        description = "Specifies the Buildbot directory.";
      };

      workerUser = lib.mkOption {
        default = "example-worker";
        type = lib.types.str;
        description = "Specifies the Buildbot Worker user.";
      };

      workerPass = lib.mkOption {
        default = "pass";
        type = lib.types.str;
        description = "Specifies the Buildbot Worker password.";
      };

      workerPassFile = lib.mkOption {
        type = lib.types.path;
        description = "File used to store the Buildbot Worker password";
      };

      hostMessage = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = "Description of this worker";
      };

      adminMessage = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.str;
        description = "Name of the administrator of this worker";
      };

      masterUrl = lib.mkOption {
        default = "localhost:9989";
        type = lib.types.str;
        description = "Specifies the Buildbot Worker connection string.";
      };

      keepalive = lib.mkOption {
        default = 600;
        type = lib.types.int;
        description = ''
          This is a number that indicates how frequently keepalive messages should be sent
          from the worker to the buildmaster, expressed in seconds.
        '';
      };

      package = lib.mkPackageOption pkgs "buildbot-worker" { };

      packages = lib.mkOption {
        default = with pkgs; [ git ];
        defaultText = lib.literalExpression "[ pkgs.git ]";
        type = lib.types.listOf lib.types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.buildbot-worker.workerPassFile = lib.mkDefault (
      pkgs.writeText "buildbot-worker-password" cfg.workerPass
    );

    users.groups = lib.optionalAttrs (cfg.group == "bbworker") {
      bbworker = { };
    };

    users.users = lib.optionalAttrs (cfg.user == "bbworker") {
      bbworker = {
        description = "Buildbot Worker User.";
        isNormalUser = true;
        createHome = true;
        home = cfg.home;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = true;
      };
    };

    systemd.services.buildbot-worker = {
      description = "Buildbot Worker.";
      after = [
        "network.target"
        "buildbot-master.service"
      ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages;
      environment.PYTHONPATH = "${python.withPackages (p: [ package ])}/${python.sitePackages}";

      preStart = ''
        mkdir -vp "${cfg.buildbotDir}/info"
        ${lib.optionalString (cfg.hostMessage != null) ''
          ln -sf "${pkgs.writeText "buildbot-worker-host" cfg.hostMessage}" "${cfg.buildbotDir}/info/host"
        ''}
        ${lib.optionalString (cfg.adminMessage != null) ''
          ln -sf "${pkgs.writeText "buildbot-worker-admin" cfg.adminMessage}" "${cfg.buildbotDir}/info/admin"
        ''}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;

        # NOTE: call twistd directly with stdout logging for systemd
        ExecStart = "${python.pkgs.twisted}/bin/twistd --nodaemon --pidfile= --logfile - --python ${tacFile}";
      };

    };
  };

  meta.maintainers = lib.teams.buildbot.members;

}
