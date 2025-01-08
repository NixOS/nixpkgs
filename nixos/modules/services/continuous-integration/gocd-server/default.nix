{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.gocd-server;
  opt = options.services.gocd-server;
in
{
  options = {
    services.gocd-server = {
      enable = lib.mkEnableOption "gocd-server";

      user = lib.mkOption {
        default = "gocd-server";
        type = lib.types.str;
        description = ''
          User the Go.CD server should execute under.
        '';
      };

      group = lib.mkOption {
        default = "gocd-server";
        type = lib.types.str;
        description = ''
          If the default user "gocd-server" is configured then this is the primary group of that user.
        '';
      };

      extraGroups = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        example = [
          "wheel"
          "docker"
        ];
        description = ''
          List of extra groups that the "gocd-server" user should be a part of.
        '';
      };

      listenAddress = lib.mkOption {
        default = "0.0.0.0";
        example = "localhost";
        type = lib.types.str;
        description = ''
          Specifies the bind address on which the Go.CD server HTTP interface listens.
        '';
      };

      port = lib.mkOption {
        default = 8153;
        type = lib.types.port;
        description = ''
          Specifies port number on which the Go.CD server HTTP interface listens.
        '';
      };

      sslPort = lib.mkOption {
        default = 8154;
        type = lib.types.int;
        description = ''
          Specifies port number on which the Go.CD server HTTPS interface listens.
        '';
      };

      workDir = lib.mkOption {
        default = "/var/lib/go-server";
        type = lib.types.str;
        description = ''
          Specifies the working directory in which the Go.CD server java archive resides.
        '';
      };

      packages = lib.mkOption {
        default = [
          pkgs.stdenv
          pkgs.jre
          pkgs.git
          config.programs.ssh.package
          pkgs.nix
        ];
        defaultText = lib.literalExpression "[ pkgs.stdenv pkgs.jre pkgs.git config.programs.ssh.package pkgs.nix ]";
        type = lib.types.listOf lib.types.package;
        description = ''
          Packages to add to PATH for the Go.CD server's process.
        '';
      };

      initialJavaHeapSize = lib.mkOption {
        default = "512m";
        type = lib.types.str;
        description = ''
          Specifies the initial java heap memory size for the Go.CD server's java process.
        '';
      };

      maxJavaHeapMemory = lib.mkOption {
        default = "1024m";
        type = lib.types.str;
        description = ''
          Specifies the java maximum heap memory size for the Go.CD server's java process.
        '';
      };

      startupOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
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
          "--add-opens=java.base/java.lang=ALL-UNNAMED"
          "--add-opens=java.base/java.util=ALL-UNNAMED"
        ];
        defaultText = lib.literalExpression ''
          [
            "-Xms''${config.${opt.initialJavaHeapSize}}"
            "-Xmx''${config.${opt.maxJavaHeapMemory}}"
            "-Dcruise.listen.host=''${config.${opt.listenAddress}}"
            "-Duser.language=en"
            "-Djruby.rack.request.size.threshold.bytes=30000000"
            "-Duser.country=US"
            "-Dcruise.config.dir=''${config.${opt.workDir}}/conf"
            "-Dcruise.config.file=''${config.${opt.workDir}}/conf/cruise-config.xml"
            "-Dcruise.server.port=''${toString config.${opt.port}}"
            "-Dcruise.server.ssl.port=''${toString config.${opt.sslPort}}"
            "--add-opens=java.base/java.lang=ALL-UNNAMED"
            "--add-opens=java.base/java.util=ALL-UNNAMED"
          ]
        '';

        description = ''
          Specifies startup command line arguments to pass to Go.CD server
          java process.
        '';
      };

      extraOptions = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
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

      environment = lib.mkOption {
        default = { };
        type = with lib.types; attrsOf str;
        description = ''
          Additional environment variables to be passed to the gocd-server process.
          As a base environment, gocd-server receives NIX_PATH from
          {option}`environment.sessionVariables`, NIX_REMOTE is set to
          "daemon".
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.optionalAttrs (cfg.group == "gocd-server") {
      gocd-server.gid = config.ids.gids.gocd-server;
    };

    users.users = lib.optionalAttrs (cfg.user == "gocd-server") {
      gocd-server = {
        description = "gocd-server user";
        createHome = true;
        home = cfg.workDir;
        group = cfg.group;
        extraGroups = cfg.extraGroups;
        useDefaultShell = true;
        uid = config.ids.uids.gocd-server;
      };
    };

    systemd.services.gocd-server = {
      description = "GoCD Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment =
        let
          selectedSessionVars = lib.filterAttrs (
            n: v: builtins.elem n [ "NIX_PATH" ]
          ) config.environment.sessionVariables;
        in
        selectedSessionVars
        // {
          NIX_REMOTE = "daemon";
        }
        // cfg.environment;

      path = cfg.packages;

      script = ''
        ${pkgs.git}/bin/git config --global --add http.sslCAinfo /etc/ssl/certs/ca-certificates.crt
        ${pkgs.jre}/bin/java -server ${lib.concatStringsSep " " cfg.startupOptions} \
                               ${lib.concatStringsSep " " cfg.extraOptions}  \
                              -jar ${pkgs.gocd-server}/go-server/lib/go.jar
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.workDir;
      };
    };
  };
}
