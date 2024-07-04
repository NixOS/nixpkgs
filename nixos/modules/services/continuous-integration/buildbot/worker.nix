# NixOS module for Buildbot Worker.

{ config, lib, options, pkgs, ... }:

with lib;

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

in {
  options = {
    services.buildbot-worker = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Buildbot Worker.";
      };

      user = mkOption {
        default = "bbworker";
        type = types.str;
        description = "User the buildbot Worker should execute under.";
      };

      group = mkOption {
        default = "bbworker";
        type = types.str;
        description = "Primary group of buildbot Worker user.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of extra groups that the Buildbot Worker user should be a part of.";
      };

      home = mkOption {
        default = "/home/bbworker";
        type = types.path;
        description = "Buildbot home directory.";
      };

      buildbotDir = mkOption {
        default = "${cfg.home}/worker";
        defaultText = literalExpression ''"''${config.${opt.home}}/worker"'';
        type = types.path;
        description = "Specifies the Buildbot directory.";
      };

      workerUser = mkOption {
        default = "example-worker";
        type = types.str;
        description = "Specifies the Buildbot Worker user.";
      };

      workerPass = mkOption {
        default = "pass";
        type = types.str;
        description = "Specifies the Buildbot Worker password.";
      };

      workerPassFile = mkOption {
        type = types.path;
        description = "File used to store the Buildbot Worker password";
      };

      hostMessage = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = "Description of this worker";
      };

      adminMessage = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = "Name of the administrator of this worker";
      };

      masterUrl = mkOption {
        default = "localhost:9989";
        type = types.str;
        description = "Specifies the Buildbot Worker connection string.";
      };

      keepalive = mkOption {
        default = 600;
        type = types.int;
        description = ''
          This is a number that indicates how frequently keepalive messages should be sent
          from the worker to the buildmaster, expressed in seconds.
        '';
      };

      package = mkPackageOption pkgs "buildbot-worker" { };

      packages = mkOption {
        default = with pkgs; [ git ];
        defaultText = literalExpression "[ pkgs.git ]";
        type = types.listOf types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.buildbot-worker.workerPassFile = mkDefault (pkgs.writeText "buildbot-worker-password" cfg.workerPass);

    users.groups = optionalAttrs (cfg.group == "bbworker") {
      bbworker = { };
    };

    users.users = optionalAttrs (cfg.user == "bbworker") {
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
      after = [ "network.target" "buildbot-master.service" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages;
      environment.PYTHONPATH = "${python.withPackages (p: [ package ])}/${python.sitePackages}";

      preStart = ''
        mkdir -vp "${cfg.buildbotDir}/info"
        ${optionalString (cfg.hostMessage != null) ''
          ln -sf "${pkgs.writeText "buildbot-worker-host" cfg.hostMessage}" "${cfg.buildbotDir}/info/host"
        ''}
        ${optionalString (cfg.adminMessage != null) ''
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
