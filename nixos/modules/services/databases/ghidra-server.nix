{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ghidra-server;

  moduleDir = "Ghidra/Features/GhidraServer";
  javaCmd = "${cfg.javaPackage}/bin/java";
  ghidraHome = "${cfg.package}/lib/ghidra";
  classpathFrag = "${ghidraHome}/${moduleDir}/build/dev-meta/classpath.frag";
  wrapperTmpDir = "/tmp";
  wrapperHome = "${ghidraHome}/${moduleDir}/data/yajsw";
in
{
  options.services.ghidra-server = {
    enable = lib.mkEnableOption "Ghidra Server, a database server for its corresponding SRE suite";

    package = lib.mkPackageOption pkgs "ghidra" { example = "ghidra-bin"; };

    javaPackage = lib.mkPackageOption pkgs "jdk21" { example = "jdk21"; };

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
      default = "0.0.0.0";
      description = "";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 13100;
      description = "";
    };

    heapMin = lib.mkOption {
      type = lib.types.int;
      default = 396;
      description = "";
    };

    heapMax = lib.mkOption {
      type = lib.types.int;
      default = 768;
      description = "";
    };

    workingDir = lib.mkOption {
      type = lib.types.path;
      default = "";
      description = "";
    };

    tmpDir = lib.mkOption {
      type = lib.types.path;
      default = "";
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
            "tls12"
            "tls13"
          ]
        );
        default = [
          "tls12"
          "tls13"
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

      sshKey = lib.mkEnableOption "the use of SSH pre-shared key for authentication when the local login method is used";

      userAutoProvision = lib.mkEnableOption "the auto-creation of new users when they successfully authenticate to the server. Only works with login methods local and jaas";

      anonymous = lib.mkEnableOption "anonymous access support for Ghidra Server and its repositories";
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

    logfile = {
      enable = lib.mkEnableOption "logging to a file";

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

      format = lib.mkOption {
        type = lib.types.str;
        default = "PM";
        description = "";
      };

      maxFiles = lib.mkOption {
        type = lib.types.int;
        default = 10;
        description = "";
      };

      maxSize = lib.mkOption {
        type = lib.types.str;
        default = "10m";
        description = "";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups."${cfg.group}" = { };
    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
    };

    systemd.services.ghidra-server = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        java = "${javaCmd}";
        ghidra_home = "${ghidraHome}";
        classpath_frag = "${classpathFrag}";
        wrapper_conf = "${wrapperTmpDir}";
      };
      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        TimeoutSec = "300";
        WorkingDirectory = "";
        ExecStart = "${javaCmd} -Djna_tmpdir='${wrapperTmpDir}' -Djava.io.tmpdir='${wrapperTmpDir}' -jar '${wrapperHome}/wrapper.jar'";
        UMask = 027;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ felixsinger ];
}
