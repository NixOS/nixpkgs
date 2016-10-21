# NixOS module for Buildbot continous integration server.

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.buildbot-master;
  configFile = if cfg.masterCfg != "" then
    pkgs.writeText "master.cfg" ''
      ${cfg.masterCfg}
    ''
    else
    pkgs.writeText "master.cfg" ''
      from buildbot.plugins import *
      c = BuildmasterConfig = {}
      c['workers'] = [ worker.Worker('${cfg.workerUser}', '${cfg.workerPass}') ]
      c['protocols'] = {'pb': {'port': ${cfg.workerPort}}}
      c['title'] = "${cfg.title}"
      c['titleURL'] = "${cfg.titleUrl}"
      c['buildbotURL'] = "${cfg.buildbotUrl}"
      c['db'] = { 'db_url' : "${cfg.dbUrl}" }
      c['www'] = dict(port=${cfg.port})

      factory = util.BuildFactory()
      for step in [ ${cfg.factorySteps} ]:
        factory.addStep(step)

      c['change_source'] = []
      for source in [ ${cfg.changeSource} ]:
        c['change_source'].append(source)

      c['schedulers'] = []
      for sched in [ ${cfg.schedulers} ]:
        c['schedulers'].append(sched)

      c['builders'] = []
      for build in [ ${cfg.builders} ]:
        c['builders'].append(build)

      c['status'] = []
      for stat in [ ${cfg.status} ]:
        c['status'].append(stat)
    '';

in {
  options = {
    services.buildbot-master = {

      ###  REQUIRED OPTIONS  ###

      factorySteps = mkOption {
        type = types.str;
        description = "Factory Steps";
        default = "";

        #example = "\\
        #  \"steps.Git(repourl='git://github.com/buildbot/pyflakes.git', mode='incremental')\", \\
        #  \"steps.ShellCommand(command=['trial', 'pyflakes'])\" \\
        #";
      };

      changeSource = mkOption {
        type = types.str;
        description = "List of Change Sources.";
        default = "";

        #example = " \\
        #  \"changes.GitPoller('git://github.com/buildbot/pyflakes.git', workdir='gitpoller-workdir', branch='master', pollinterval=300)\" \\
        #";
      };


      ###  DEFAULTED OPTIONS  ###

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the Buildbot continuous integration server.";
      };

      masterCfg = mkOption {
        type = types.str;
        description = "Optionally pass entire raw master.cfg file.";
        default = "";
      };

      schedulers = mkOption {
        type = types.str;
        description = "List of Schedulers.";
        default = " \\
          \"schedulers.SingleBranchScheduler(name='all', change_filter=util.ChangeFilter(branch='master'), treeStableTimer=None, builderNames=['runtests'])\", \\
          \"schedulers.ForceScheduler(name='force',builderNames=['runtests'])\" \\
        ";
      };

      builders = mkOption {
        type = types.str;
        description = "List of Builders.";
        default = " \\
          \"util.BuilderConfig(name='runtests',workernames=['default-worker'],factory=factory)\" \\
        ";
      };

      status = mkOption {
        default = "";
        type = types.str;
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
        default = [ "nixbld" ];
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

      workerUser = mkOption {
        default = "default-worker";
        type = types.str;
        description = "Buildbot Worker User.";
      };

      workerPass = mkOption {
        default = "pass";
        type = types.str;
        description = "Buildbot Worker Password.";
      };

      workerPort = mkOption {
        default = "9989";
        type = types.str;
        description = "Buildbot Worker Port.";
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
        default = "8010";
        type = types.str;
        description = "Specifies port number on which the buildbot HTTP interface listens.";
      };

      packages = mkOption {
        default = [ pkgs.buildbot-ui ];
        type = types.listOf types.package;
        description = "Packages to add to PATH for the buildbot process.";
      };

      environment = mkOption {
        default = {};
        type = with types; attrsOf str;
        description = "Additional environment variables to be passed.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "buildbot") {
      name = "buildbot";
    };

    users.extraUsers = optional (cfg.user == "buildbot") {
      name = "buildbot";
      description = "buildbot user";
      isNormalUser = true;
      createHome = true;
      home = cfg.home;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
    };

    systemd.services.buildbot-master = {
      description = "Buildbot Continuous Integration Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = cfg.packages;

      serviceConfig = {
        Type = "forking";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.home;
      };

      preStart = ''
        mkdir -vp ${cfg.buildbotDir}
        chown -c ${cfg.user}:${cfg.group} ${cfg.buildbotDir}
        cat ${configFile} | tee ${cfg.buildbotDir}/master.cfg
        ${pkgs.buildbot-ui}/bin/buildbot create-master ${cfg.buildbotDir}
      '';

      script = "${pkgs.buildbot-ui}/bin/buildbot start ${cfg.buildbotDir}";

      postStart = ''
        until [[ $(${pkgs.curl}/bin/curl -s --head -w '\n%{http_code}' http://localhost:${cfg.port} | tail -n1) =~ ^(200|403)$ ]]; do
          sleep 1
        done
      '';
    };
  };

}
