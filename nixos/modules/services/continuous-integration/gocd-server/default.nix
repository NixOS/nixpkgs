{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gocd-server;
in {
  options = {
    services.gocd-server = {
      enable = mkEnableOption "gocd-server";

      user = mkOption {
        default = "gocd-server";
        type = types.str;
        description = ''
          User the Go.CD server should execute under.
        '';
      };

      group = mkOption {
        default = "gocd-server";
        type = types.str;
        description = ''
          If the default user "gocd-server" is configured then this is the primary group of that user.
        '';
      };

      extraGroups = mkOption {
        default = [ ];
        example = [ "wheel" "docker" ];
        description = ''
          List of extra groups that the "gocd-server" user should be a part of.
        '';
      };

      listenAddress = mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = types.str;
        description = ''
          Specifies the bind address on which the Go.CD server HTTP interface listens.
        '';
      };

      port = mkOption {
        default = 8153;
        type = types.int;
        description = ''
          Specifies port number on which the Go.CD server HTTP interface listens.
        '';
      };

      sslPort = mkOption {
        default = 8154;
        type = types.int;
        description = ''
          Specifies port number on which the Go.CD server HTTPS interface listens.
        '';
      };

      workDir = mkOption {
        default = "/var/lib/go-server";
        type = types.str;
        description = ''
          Specifies the working directory in which the Go.CD server java archive resides.
        '';
      };

      packages = mkOption {
        default = [ pkgs.stdenv pkgs.jre pkgs.git config.programs.ssh.package pkgs.nix ];
        type = types.listOf types.package;
        description = ''
          Packages to add to PATH for the Go.CD server's process.
        '';
      };

      initialJavaHeapSize = mkOption {
        default = "512m";
        type = types.str;
        description = ''
          Specifies the initial java heap memory size for the Go.CD server's java process.
        '';
      };

      maxJavaHeapMemory = mkOption {
        default = "1024m";
        type = types.str;
        description = ''
          Specifies the java maximum heap memory size for the Go.CD server's java process.
        '';
      };

      extraOptions = mkOption {
        default = [
          "-Xms${cfg.initialJavaHeapSize}"
          "-Xmx${cfg.maxJavaHeapMemory}"
          "-Dcruise.listen.host=${cfg.listenAddress}"
          "-Duser.language=en"
          "-Djruby.rack.request.size.threshold.bytes=30000000"
          "-Duser.country=US"
          "-Dcruise.config.dir=${cfg.workDir}/conf"
          "-Dcruise.config.file=${cfg.workDir}/conf/cruise-config.xml"
          "-Dcruise.server.port=${toString cfg.port}"
          "-Dcruise.server.ssl.port=${toString cfg.sslPort}"
        ];
        example = [ 
          "-X debug" 
          "-Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5005"
          "-verbose:gc"
          "-Xloggc:go-server-gc.log"
          "-XX:+PrintGCTimeStamps"
          "-XX:+PrintTenuringDistribution"
          "-XX:+PrintGCDetails"
          "-XX:+PrintGC"
        ];
        description = ''
          Specifies additional command line arguments to pass to Go.CD server's
          java process.  Example contains debug and gcLog arguments.
        '';
      };

      environment = mkOption {
        default = { };
        type = with types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the gocd-server process.
          As a base environment, gocd-server receives NIX_PATH from
          <option>environment.sessionVariables</option>, NIX_REMOTE is set to
          "daemon".
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraGroups = optional (cfg.group == "gocd-server") {
      name = "gocd-server";
      gid = config.ids.gids.gocd-server;
    };

    users.extraUsers = optional (cfg.user == "gocd-server") {
      name = "gocd-server";
      description = "gocd-server user";
      createHome = true;
      home = cfg.workDir;
      group = cfg.group;
      extraGroups = cfg.extraGroups;
      useDefaultShell = true;
      uid = config.ids.uids.gocd-server;
    };

    systemd.services.gocd-server = {
      description = "GoCD Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment =
        let
          selectedSessionVars =
            lib.filterAttrs (n: v: builtins.elem n [ "NIX_PATH" ])
              config.environment.sessionVariables;
        in
          selectedSessionVars //
            { NIX_REMOTE = "daemon";
            } //
            cfg.environment;

      path = cfg.packages;

      script = ''
        ${pkgs.git}/bin/git config --global --add http.sslCAinfo /etc/ssl/certs/ca-certificates.crt
        ${pkgs.jre}/bin/java -server ${concatStringsSep " " cfg.extraOptions} \
                              -jar ${pkgs.gocd-server}/go-server/go.jar
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.workDir;
      };
    };
  };
}
