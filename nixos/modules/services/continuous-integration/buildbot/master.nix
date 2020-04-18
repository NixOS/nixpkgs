# NixOS module for Buildbot continous integration server.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildbot-master;

  python = cfg.package.pythonModule;

  escapeStr = s: escape ["'"] s;

  defaultMasterCfg = pkgs.writeText "master.cfg" ''
    from buildbot.plugins import *
    factory = util.BuildFactory()
    c = BuildmasterConfig = dict(
     workers       = [${concatStringsSep "," cfg.workers}],
     protocols     = { 'pb': {'port': ${toString cfg.bpPort} } },
     title         = '${escapeStr cfg.title}',
     titleURL      = '${escapeStr cfg.titleUrl}',
     buildbotURL   = '${escapeStr cfg.buildbotUrl}',
     db            = dict(db_url='${escapeStr cfg.dbUrl}'),
     www           = dict(port=${toString cfg.port}),
     change_source = [ ${concatStringsSep "," cfg.changeSource} ],
     schedulers    = [ ${concatStringsSep "," cfg.schedulers} ],
     builders      = [ ${concatStringsSep "," cfg.builders} ],
     status        = [ ${concatStringsSep "," cfg.status} ],
    )
    for step in [ ${concatStringsSep "," cfg.factorySteps} ]:
      factory.addStep(step)

    ${cfg.extraConfig}
  '';

  tacFile = pkgs.writeText "buildbot-master.tac" ''
    import os

    from twisted.application import service
    from buildbot.master import BuildMaster

    basedir = '${cfg.buildbotDir}'

    configfile = '${cfg.masterCfg}'

    # Default umask for server
    umask = None

    # note: this line is matched against to check that this is a buildmaster
    # directory; do not edit it.
    application = service.Application('buildmaster')

    m = BuildMaster(basedir, configfile, umask)
    m.setServiceParent(application)
  '';

in {
  options = {
    services.buildbot-master = {

      factorySteps = mkOption {
        type = types.listOf types.str;
        description = "Factory Steps";
        default = [];
        example = [
          "steps.Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')"
          "steps.ShellCommand(command=['trial', 'pyflakes'])"
        ];
      };

      changeSource = mkOption {
        type = types.listOf types.str;
        description = "List of Change Sources.";
        default = [];
        example = [
          "changes.GitPoller('git://github.com/buildbot/pyflakes.git', workdir='gitpoller-workdir', branch='master', pollinterval=300)"
        ];
      };

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Buildbot continuous integration server.";
      };

      extraConfig = mkOption {
        type = types.str;
        description = "Extra configuration to append to master.cfg";
        default = "c['buildbotNetUsageData'] = None";
      };

      masterCfg = mkOption {
        type = types.path;
        description = "Optionally pass master.cfg path. Other options in this configuration will be ignored.";
        default = defaultMasterCfg;
        example = "/etc/nixos/buildbot/master.cfg";
      };

      schedulers = mkOption {
        type = types.listOf types.str;
        description = "List of Schedulers.";
        default = [
          "schedulers.SingleBranchScheduler(name='all', change_filter=util.ChangeFilter(branch='master'), treeStableTimer=None, builderNames=['runtests'])"
          "schedulers.ForceScheduler(name='force',builderNames=['runtests'])"
        ];
      };

      builders = mkOption {
        type = types.listOf types.str;
        description = "List of Builders.";
        default = [
          "util.BuilderConfig(name='runtests',workernames=['example-worker'],factory=factory)"
        ];
      };

      workers = mkOption {
        type = types.listOf types.str;
        description = "List of Workers.";
        default = [ "worker.Worker('example-worker', 'pass')" ];
      };

      status = mkOption {
        default = [];
        type = types.listOf types.str;
        description = "List of status notification endpoints.";
      };

      user = mkOption {
        default = "buildbot";
        type = types.str;
        description = "User the buildbot server should execute under.";
      };

      group = mkOption {
        default = "buildbot";
        type = types.str;
        description = "Primary group of buildbot user.";
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of extra groups that the buildbot user should be a part of.";
      };

      home = mkOption {
        default = "/home/buildbot";
        type = types.path;
        description = "Buildbot home directory.";
      };

      buildbotDir = mkOption {
        default = "${cfg.home}/master";
        type = types.path;
        description = "Specifies the Buildbot directory.";
      };

      bpPort = mkOption {
        default = 9989;
        type = types.int;
        description = "Port where the master will listen to Buildbot Worker.";
      };

      listenAddress = mkOption {
        default = "0.0.0.0";
        type = types.str;
        description = "Specifies the bind address on which the buildbot HTTP interface listens.";
      };

      buildbotUrl = mkOption {
        default = "http://localhost:8010/";
        type = types.str;
        description = "Specifies the Buildbot URL.";
      };

      title = mkOption {
        default = "Buildbot";
        type = types.str;
        description = "Specifies the Buildbot Title.";
      };

      titleUrl = mkOption {
        default = "Buildbot";
        type = types.str;
        description = "Specifies the Buildbot TitleURL.";
      };

      dbUrl = mkOption {
        default = "sqlite:///state.sqlite";
        type = types.str;
        description = "Specifies the database connection string.";
      };

      port = mkOption {
        default = 8010;
        type = types.int;
        description = "Specifies port number on which the buildbot HTTP interface listens.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.python3Packages.buildbot-full;
        defaultText = "pkgs.python3Packages.buildbot-full";
        description = "Package to use for buildbot.";
        example = literalExample "pkgs.python3Packages.buildbot";
      };

      packages = mkOption {
        default = [ pkgs.git ];
        example = literalExample "[ pkgs.git ]";
        type = types.listOf types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };

      pythonPackages = mkOption {
        default = pythonPackages: with pythonPackages; [ ];
        defaultText = "pythonPackages: with pythonPackages; [ ]";
        description = "Packages to add the to the PYTHONPATH of the buildbot process.";
        example = literalExample "pythonPackages: with pythonPackages; [ requests ]";
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups = optionalAttrs (cfg.group == "buildbot") {
      buildbot = { };
    };

    users.users = optionalAttrs (cfg.user == "buildbot") {
      buildbot = {
        description = "Buildbot User.";
        isNormalUser = true;
        createHome = true;
        home = cfg.home;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = true;
      };
    };

    systemd.services.buildbot-master = {
      description = "Buildbot Continuous Integration Server.";
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages ++ cfg.pythonPackages python.pkgs;
      environment.PYTHONPATH = "${python.withPackages (self: cfg.pythonPackages self ++ [ cfg.package ])}/${python.sitePackages}";

      preStart = ''
        mkdir -vp "${cfg.buildbotDir}"
        # Link the tac file so buildbot command line tools recognize the directory
        ln -sf "${tacFile}" "${cfg.buildbotDir}/buildbot.tac"
        ${cfg.package}/bin/buildbot create-master --db "${cfg.dbUrl}" "${cfg.buildbotDir}"
        rm -f buildbot.tac.new master.cfg.sample
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;
        # NOTE: call twistd directly with stdout logging for systemd
        ExecStart = "${python.pkgs.twisted}/bin/twistd -o --nodaemon --pidfile= --logfile - --python ${tacFile}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ nand0p mic92 ];
}
