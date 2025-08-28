{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ghidra-server;

  authType =
    if cfg.authentication.type == "local" then
      "-a0"
    else if cfg.authentication.type == "pki" then
      "-a2"
    else if cfg.authentication.type == "jaas" then
      "-a4"
    else
      null;

  ghidraServerConfig = pkgs.writeText "ghidra-server.conf" ''
    wrapper.working.dir=''${ghidra_home}
    wrapper.tmp.path=''${wrapper_tmpdir}
    include=''${classpath_frag}

    wrapper.java.app.mainclass=ghidra.server.remote.GhidraServer
    wrapper.java.command=''${java}
    wrapper.java.umask=027
    # TODO: Figure out if IPv6 is supported
    wrapper.java.additional.1=-Djava.net.preferIPv4Stack=true
    # TODO: Figure out if file logging may be disabled
    wrapper.java.additional.2=-DApplicationRollingFileAppender.maxBackupIndex=10
    wrapper.java.additional.3=-Dclasspath_frag=''${classpath_frag}
    wrapper.java.additional.4=-Djava.io.tmpdir=''${wrapper_tmpdir}
    wrapper.java.additional.5=-Djna.tmpdir=''${wrapper_tmpdir}
    wrapper.java.additional.6=-Dghidra.tls.server.protocols=${lib.strings.concatStringsSep ";" cfg.tls.protocols}
    wrapper.java.additional.7=-Djdk.tls.server.cipherSuites=${lib.strings.concatStringsSep "\\," cfg.tls.cipherSuites}
    # TODO: Enable PKI authentication
    # wrapper.java.additional.8=-Dghidra.cacerts=./Ghidra/cacerts
    # TODO: Make TLS certs configurable
    # wrapper.java.additional.9=-Dghidra.keystore=
    # wrapper.java.additional.10=-Dghidra.password=
    wrapper.java.additional.11=-Ddb.buffers.DataBuffer.compressedOutput=true
    wrapper.java.initmemory=${toString cfg.heapMin}
    wrapper.java.maxmemory=${toString cfg.heapMax}

    ghidra.repositories.dir=${cfg.repositoryDir}

    wrapper.app.parameter.1=${authType}
    ${if (!cfg.authentication.useClientLogin) then "wrapper.app.parameter.2=-u" else ""}
    wrapper.app.parameter.3=-ip ${cfg.address}
    wrapper.app.parameter.4=-i ${cfg.address}
    wrapper.app.parameter.5=-p${toString cfg.port}
    ${if cfg.authentication.useAutoProvision then "wrapper.app.parameter.6=-autoProvision" else ""}
    ${if cfg.authentication.allowAnonymous then "wrapper.app.parameter.7=-anonymous" else ""}
    wrapper.app.parameter.8=${cfg.repositoryDir}
    wrapper.app.account=${cfg.user}

    wrapper.console.title=${cfg.console.title}
    wrapper.console.loglevel=${cfg.console.loglevel}
    wrapper.console.format=${cfg.console.format}

    wrapper.logfile=

    wrapper.lockfile=/run/ghidra-server/ghidra-server.lck
    wrapper.pidfile=/run/ghidra-server/ghidra-server.pid
  '';
in
{
  options.services.ghidra-server = {
    enable = lib.mkEnableOption "Ghidra Server, a database server for its corresponding SRE suite";

    package = lib.mkPackageOption pkgs "ghidra" { example = "ghidra-bin"; };

    javaPackage = lib.mkPackageOption pkgs "jdk21" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "ghidra-server";
      description = "";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "ghidra-server";
      description = "";
    };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 13100;
      description = "";
    };

    heapMin = lib.mkOption {
      type = lib.types.ints.positive;
      default = 396;
      description = "";
    };

    heapMax = lib.mkOption {
      type = lib.types.ints.positive;
      default = 768;
      description = "";
    };

    repositoryDir = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = "";
    };

    tls = {
      protocols = lib.mkOption {
        type = lib.types.listOf (
          lib.types.enum [
            "TLSv1.2"
            "TLSv1.3"
          ]
        );
        default = [
          "TLSv1.2"
          "TLSv1.3"
        ];
        description = "";
      };

      cipherSuites = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "TLS_DHE_RSA_WITH_AES_256_GCM_SHA384"
          "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
          "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384"
          "TLS_AES_256_GCM_SHA384"
        ];
        description = "";
      };
    };

    authentication = {
      type = lib.mkOption {
        type = lib.types.enum [
          "local"
          "pki"
          "jaas"
        ];
        default = "local";
        description = "";
      };

      useClientLogin = lib.mkEnableOption "the use of the client-side login ID";

      sshKey = lib.mkEnableOption "the use of SSH pre-shared key for authentication when the local login method is used";

      useAutoProvision = lib.mkEnableOption "the auto-creation of new users when they successfully authenticate to the server. Only works with login methods local and jaas";

      allowAnonymous = lib.mkEnableOption "anonymous access support for Ghidra Server and its repositories";
    };

    console = {
      title = lib.mkOption {
        type = lib.types.str;
        default = "Ghidra Server";
        description = "";
      };

      format = lib.mkOption {
        type = lib.types.str;
        default = "PM";
        description = "";
      };

      loglevel = lib.mkOption {
        type = lib.types.enum [
          "NONE"
          "FATAL"
          "ERROR"
          "STATUS"
          "INFO"
          "DEBUG"
        ];
        default = "INFO";
        description = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups."${cfg.group}" = { };
    users.users."${cfg.user}" = {
      isSystemUser = true;
      home = cfg.repositoryDir;
      shell = "/run/current-system/sw/bin/sh";
      group = cfg.group;
      packages = [
        cfg.javaPackage
      ];
    };

    systemd.tmpfiles.rules = [
      "L+ /etc/ghidra-server.conf - - - - ${ghidraServerConfig}"
    ];

    systemd.services.ghidra-server = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.javaPackage ];
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        RuntimeDirectory = "ghidra-server";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "ghidra-server";
        ExecStart = "${cfg.package}/lib/ghidra/server/ghidraSvr console";
        UMask = 027;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
