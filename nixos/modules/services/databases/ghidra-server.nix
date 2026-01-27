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

  mapToIndexedAttrs = xs: lib.attrsToList (lib.imap0 (i: lib.nameValuePair (toString i)) xs);

  ghidraServerConfig = lib.filterAttrsRecursive (_: v: v != null) {
    wrapper.working.dir = "$${ghidra_home}";
    wrapper.tmp.path = "$${wrapper_tmpdir}";
    include = "$${classpath_frag}";

    wrapper.java.app.mainclass = "ghidra.server.remote.GhidraServer";
    wrapper.java.command = "$${java}";
    wrapper.java.umask = 027;
    wrapper.java.initmemory = cfg.heapMin;
    wrapper.java.maxmemory = cfg.heapMax;

    wrapper.java.additional = mapToIndexedAttrs [
      # TODO: Figure out if IPv6 is supported
      "-Djava.net.preferIPv4Stack=true"
      # TODO: Figure out if file logging may be disabled
      "-DApplicationRollingFileAppender.maxBackupIndex=10"
      "-Dclasspath_frag=$${classpath_frag}"
      "-Djava.io.tmpdir=$${wrapper_tmpdir}"
      "-Djna.tmpdir=$${wrapper_tmpdir}"
      "-Dghidra.tls.server.protocols=${lib.strings.concatStringsSep ";" cfg.tls.protocols}"
      "-Djdk.tls.server.cipherSuites=${lib.strings.concatStringsSep "\\," cfg.tls.cipherSuites}"
      # TODO: Enable PKI authentication
      # "-Dghidra.cacerts=./Ghidra/cacerts";
      # TODO: Make TLS certs configurable
      # "-Dghidra.keystore=";
      # "-Dghidra.password=";
      "-Ddb.buffers.DataBuffer.compressedOutput=true"
    ];

    ghidra.repositories.dir = cfg.repositoryDir;

    wrapper.app.parameter = mapToIndexedAttrs [
      authType
      (if (!cfg.authentication.useClientLogin) then "-u" else null)
      "-ip ${cfg.address}"
      "-i ${cfg.address}"
      "-p${toString cfg.port}"
      (if cfg.authentication.useAutoProvision then "-autoProvision" else null)
      (if cfg.authentication.allowAnonymous then "-anonymous" else null)
      cfg.repositoryDir
    ];

    wrapper.app.account = cfg.user;

    wrapper.console.title = cfg.console.title;
    wrapper.console.loglevel = cfg.console.loglevel;
    wrapper.console.format = cfg.console.format;

    wrapper.logfile = "";

    wrapper.lockfile = "/run/ghidra-server/ghidra-server.lck";
    wrapper.pidfile = "/run/ghidra-server/ghidra-server.pid";
  };

  ghidraServerConfigFile =
    (pkgs.formats.javaProperties { }).generate "ghidra-server.conf"
      ghidraServerConfig;
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
      "L+ /etc/ghidra-server.conf - - - - ${ghidraServerConfigFile}"
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
