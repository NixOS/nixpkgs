# NixOS module for Buildbot continuous integration server.

{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.buildbot-master;
  opt = options.services.buildbot-master;

  package = pkgs.python3.pkgs.toPythonModule cfg.package;
  python = package.pythonModule;

  escapeStr = escape [ "'" ];

  defaultMasterCfg = pkgs.writeText "master.cfg" ''
    from buildbot.plugins import *
    ${cfg.extraImports}
    factory = util.BuildFactory()
    c = BuildmasterConfig = dict(
     workers       = [${concatStringsSep "," cfg.workers}],
     protocols     = { 'pb': {'port': ${toString cfg.pbPort} } },
     title         = '${escapeStr cfg.title}',
     titleURL      = '${escapeStr cfg.titleUrl}',
     buildbotURL   = '${escapeStr cfg.buildbotUrl}',
     db            = dict(db_url='${escapeStr cfg.dbUrl}'),
     www           = dict(port=${toString cfg.port}),
     change_source = [ ${concatStringsSep "," cfg.changeSource} ],
     schedulers    = [ ${concatStringsSep "," cfg.schedulers} ],
     builders      = [ ${concatStringsSep "," cfg.builders} ],
     services      = [ ${concatStringsSep "," cfg.reporters} ],
     configurators = [ ${concatStringsSep "," cfg.configurators} ],
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
          "steps.Git(repourl='https://github.com/buildbot/pyflakes.git', mode='incremental')"
          "steps.ShellCommand(command=['trial', 'pyflakes'])"
        ];
      };

      changeSource = mkOption {
        type = types.listOf types.str;
        description = "List of Change Sources.";
        default = [];
        example = [
          "changes.GitPoller('https://github.com/buildbot/pyflakes.git', workdir='gitpoller-workdir', branch='master', pollinterval=300)"
        ];
      };

      configurators = mkOption {
        type = types.listOf types.str;
        description = "Configurator Steps, see https://docs.buildbot.net/latest/manual/configuration/configurators.html";
        default = [];
        example = [
          "util.JanitorConfigurator(logHorizon=timedelta(weeks=4), hour=12, dayOfWeek=6)"
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

      extraImports = mkOption {
        type = types.str;
        description = "Extra python imports to prepend to master.cfg";
        default = "";
        example = "from buildbot.process.project import Project";
      };

      masterCfg = mkOption {
        type = types.path;
        description = "Optionally pass master.cfg path. Other options in this configuration will be ignored.";
        default = defaultMasterCfg;
        defaultText = literalMD ''generated configuration file'';
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

      reporters = mkOption {
        default = [];
        type = types.listOf types.str;
        description = "List of reporter objects used to present build status to various users.";
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
        defaultText = literalExpression ''"''${config.${opt.home}}/master"'';
        type = types.path;
        description = "Specifies the Buildbot directory.";
      };

      pbPort = mkOption {
        default = 9989;
        type = types.either types.str types.int;
        example = "'tcp:9990:interface=127.0.0.1'";
        description = ''
          The buildmaster will listen on a TCP port of your choosing
          for connections from workers.
          It can also use this port for connections from remote Change Sources,
          status clients, and debug tools.
          This port should be visible to the outside world, and you’ll need to tell
          your worker admins about your choice.
          If put in (single) quotes, this can also be used as a connection string,
          as defined in the [ConnectionStrings guide](https://twistedmatrix.com/documents/current/core/howto/endpoints.html).
        '';
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
        type = types.port;
        description = "Specifies port number on which the buildbot HTTP interface listens.";
      };

      package = mkPackageOption pkgs "buildbot-full" {
        example = "buildbot";
      };

      packages = mkOption {
        default = [ pkgs.git ];
        defaultText = literalExpression "[ pkgs.git ]";
        type = types.listOf types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };

      pythonPackages = mkOption {
        type = types.functionTo (types.listOf types.package);
        default = pythonPackages: with pythonPackages; [ ];
        defaultText = literalExpression "pythonPackages: with pythonPackages; [ ]";
        description = "Packages to add the to the PYTHONPATH of the buildbot process.";
        example = literalExpression "pythonPackages: with pythonPackages; [ requests ]";
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
        inherit (cfg) home group extraGroups;
        useDefaultShell = true;
      };
    };

    systemd.services.buildbot-master = {
      description = "Buildbot Continuous Integration Server.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages ++ cfg.pythonPackages python.pkgs;
      environment.PYTHONPATH = "${python.withPackages (self: cfg.pythonPackages self ++ [ package ])}/${python.sitePackages}";

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
        ExecStart = "${python.pkgs.twisted}/bin/twistd -o --nodaemon --pidfile= --logfile - --python ${cfg.buildbotDir}/buildbot.tac";
        # To reload on upgrade, set the following in your configuration:
        # systemd.services.buildbot-master.reloadIfChanged = true;
        ExecReload = [
          "${pkgs.coreutils}/bin/ln -sf ${tacFile} ${cfg.buildbotDir}/buildbot.tac"
          "${pkgs.coreutils}/bin/kill -HUP $MAINPID"
        ];
      };
    };
  };

  imports = [
    (mkRenamedOptionModule [ "services" "buildbot-master" "bpPort" ] [ "services" "buildbot-master" "pbPort" ])
    (mkRemovedOptionModule [ "services" "buildbot-master" "status" ] ''
      Since Buildbot 0.9.0, status targets are deprecated and ignored.
      Review your configuration and migrate to reporters (available at services.buildbot-master.reporters).
    '')
  ];

  meta.maintainers = lib.teams.buildbot.members;
}
