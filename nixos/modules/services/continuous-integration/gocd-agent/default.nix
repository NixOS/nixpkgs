{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gocd-agent;
in {
  options = {
    services.gocd-agent = {
      enable = mkEnableOption "gocd-agent";

      user = mkOption {
        default = "gocd-agent";
        type = types.str;
        description = ''
          User the Go.CD agent should execute under.
        '';
      };

      group = mkOption {
        default = "gocd-agent";
        type = types.str;
        description = ''
          If the default user "gocd-agent" is configured then this is the primary
          group of that user.
        '';
      };

      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "wheel" "docker" ];
        description = ''
          List of extra groups that the "gocd-agent" user should be a part of.
        '';
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.jre pkgs.git config.programs.ssh.package pkgs.nix ];
        defaultText = "[ pkgs.stdenv pkgs.jre pkgs.git config.programs.ssh.package pkgs.nix ]";
        type = types.listOf types.package;
        description = ''
          Packages to add to PATH for the Go.CD agent process.
        '';
      };

      agentConfig = mkOption {
        default = "";
        type = types.str;
        example = ''
          agent.auto.register.resources=ant,java
          agent.auto.register.environments=QA,Performance
          agent.auto.register.hostname=Agent01
        '';
        description = ''
          Agent registration configuration.
        '';
      };

      goServer = mkOption {
        default = "https://127.0.0.1:8154/go";
        type = types.str;
        description = ''
          URL of the GoCD Server to attach the Go.CD Agent to.
        '';
      };

      workDir = mkOption {
        default = "/var/lib/go-agent";
        type = types.str;
        description = ''
          Specifies the working directory in which the Go.CD agent java archive resides.
        '';
      };

      initialJavaHeapSize = mkOption {
        default = "128m";
        type = types.str;
        description = ''
          Specifies the initial java heap memory size for the Go.CD agent java process.
        '';
      };

      maxJavaHeapMemory = mkOption {
        default = "256m";
        type = types.str;
        description = ''
          Specifies the java maximum heap memory size for the Go.CD agent java process.
        '';
      };

      startupOptions = mkOption {
        default = [
          "-Xms${cfg.initialJavaHeapSize}"
          "-Xmx${cfg.maxJavaHeapMemory}"
          "-Djava.io.tmpdir=/tmp"
          "-Dcruise.console.publish.interval=10"
          "-Djava.security.egd=file:/dev/./urandom"
        ];
        description = ''
          Specifies startup command line arguments to pass to Go.CD agent
          java process.
        '';
      };

      extraOptions = mkOption {
        default = [ ];
        example = [
          "-X debug"
          "-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5006"
          "-verbose:gc"
          "-Xloggc:go-agent-gc.log"
          "-XX:+PrintGCTimeStamps"
          "-XX:+PrintTenuringDistribution"
          "-XX:+PrintGCDetails"
          "-XX:+PrintGC"
        ];
        description = ''
          Specifies additional command line arguments to pass to Go.CD agent
          java process.  Example contains debug and gcLog arguments.
        '';
      };

      environment = mkOption {
        default = { };
        type = with types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the Go.CD agent process.
          As a base environment, Go.CD agent receives NIX_PATH from
          <option>environment.sessionVariables</option>, NIX_REMOTE is set to
          "daemon".
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups = optionalAttrs (cfg.group == "gocd-agent") {
      gocd-agent.gid = config.ids.gids.gocd-agent;
    };

    users.users = optionalAttrs (cfg.user == "gocd-agent") {
      gocd-agent = {
        description = "gocd-agent user";
        createHome = true;
        home = cfg.workDir;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = true;
        uid = config.ids.uids.gocd-agent;
      };
    };

    systemd.services.gocd-agent = {
      description = "GoCD Agent";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment =
        let
          selectedSessionVars =
            lib.filterAttrs (n: v: builtins.elem n [ "NIX_PATH" ])
              config.environment.sessionVariables;
        in
          selectedSessionVars //
            {
              NIX_REMOTE = "daemon";
              AGENT_WORK_DIR = cfg.workDir;
              AGENT_STARTUP_ARGS = ''${concatStringsSep " "  cfg.startupOptions}'';
              LOG_DIR = cfg.workDir;
              LOG_FILE = "${cfg.workDir}/go-agent-start.log";
            } //
            cfg.environment;

      path = cfg.packages;

      script = ''
        MPATH="''${PATH}";
        source /etc/profile
        export PATH="''${MPATH}:''${PATH}";

        if ! test -f ~/.nixpkgs/config.nix; then
          mkdir -p ~/.nixpkgs/
          echo "{ allowUnfree = true; }" > ~/.nixpkgs/config.nix
        fi

        mkdir -p config
        rm -f config/autoregister.properties
        ln -s "${pkgs.writeText "autoregister.properties" cfg.agentConfig}" config/autoregister.properties

        ${pkgs.git}/bin/git config --global --add http.sslCAinfo /etc/ssl/certs/ca-certificates.crt
        ${pkgs.jre}/bin/java ${concatStringsSep " " cfg.startupOptions} \
                        ${concatStringsSep " " cfg.extraOptions} \
                              -jar ${pkgs.gocd-agent}/go-agent/agent-bootstrapper.jar \
                              -serverUrl ${cfg.goServer}
      '';

      serviceConfig = {
        User = cfg.user;
        WorkingDirectory = cfg.workDir;
        RestartSec = 30;
        Restart = "on-failure";
      };
    };
  };
}
