# NixOS module for Buildbot continous integration server.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildbot-master;
  escapeStr = s: escape ["'"] s;
  masterCfg = if cfg.masterCfg == null then pkgs.writeText "master.cfg" ''
    from buildbot.plugins import *
    factory = util.BuildFactory()
    c = BuildmasterConfig = dict(
     workers       = [${concatStringsSep "," cfg.workers}],
     protocols     = { 'pb': {'port': ${cfg.bpPort} } },
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
  ''
  else cfg.masterCfg;

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
        default = "";
      };

      masterCfg = mkOption {
        type = types.nullOr types.path;
        description = "Optionally pass master.cfg path. Other options in this configuration will be ignored.";
        default = null;
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
        default = [
          "worker.Worker('example-worker', 'pass')"
        ];
        example = [ "worker.LocalWorker('example-worker')" ];
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
        default = "9989";
        type = types.string;
        example = "tcp:10000:interface=127.0.0.1";
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
        default = pkgs.buildbot-ui;
        defaultText = "pkgs.buildbot-ui";
        description = "Package to use for buildbot.";
        example = literalExample "pkgs.buildbot-full";
      };

      packages = mkOption {
        default = [ ];
        example = literalExample "[ pkgs.git ]";
        type = types.listOf types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "buildbot") {
      name = "buildbot";
    };

    users.extraUsers = optional (cfg.user == "buildbot") {
      name = "buildbot";
      description = "Buildbot User.";
      isNormalUser = true;
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
    };

    systemd.services.buildbot-master = {
      description = "Buildbot Continuous Integration Server.";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;
        ExecStart = "${cfg.package}/bin/buildbot start --nodaemon ${cfg.buildbotDir}";
      };

      preStart = ''
        ${pkgs.coreutils}/bin/mkdir -vp ${cfg.buildbotDir}
        ${pkgs.coreutils}/bin/ln -sfv ${masterCfg} ${cfg.buildbotDir}/master.cfg
        ${cfg.package}/bin/buildbot create-master ${cfg.buildbotDir}
      '';

      postStart = ''
        until [[ $(${pkgs.curl}/bin/curl -s --head -w '\n%{http_code}' http://localhost:${toString cfg.port} | tail -n1) =~ ^(200|403)$ ]]; do
          sleep 1
        done
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [ nand0p Mic92 ];

}
