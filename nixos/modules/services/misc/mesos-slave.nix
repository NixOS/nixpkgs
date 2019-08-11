{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mesos.slave;

  mkAttributes =
    attrs: concatStringsSep ";" (mapAttrsToList
                                   (k: v: "${k}:${v}")
                                   (filterAttrs (k: v: v != null) attrs));
  attribsArg = optionalString (cfg.attributes != {})
                              "--attributes=${mkAttributes cfg.attributes}";

  containerizersArg = concatStringsSep "," (
    lib.unique (
      cfg.containerizers ++ (optional cfg.withDocker "docker")
    )
  );

  imageProvidersArg = concatStringsSep "," (
    lib.unique (
      cfg.imageProviders ++ (optional cfg.withDocker "docker")
    )
  );

  isolationArg = concatStringsSep "," (
    lib.unique (
      cfg.isolation ++ (optionals cfg.withDocker [ "filesystem/linux" "docker/runtime"])
    )
  );

in {

  options.services.mesos = {
    slave = {
      enable = mkOption {
        description = "Whether to enable the Mesos Slave.";
        default = false;
        type = types.bool;
      };

      ip = mkOption {
        description = "IP address to listen on.";
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "Port to listen on.";
        default = 5051;
        type = types.int;
      };

      advertiseIp = mkOption {
        description = "IP address advertised to reach this agent.";
        default = null;
        type = types.nullOr types.str;
      };

      advertisePort = mkOption {
        description = "Port advertised to reach this agent.";
        default = null;
        type = types.nullOr types.int;
      };

      containerizers = mkOption {
        description = ''
          List of containerizer implementations to compose in order to provide
          containerization. Available options are mesos and docker.
          The order the containerizers are specified is the order they are tried.
        '';
        default = [ "mesos" ];
        type = types.listOf types.str;
      };

      imageProviders = mkOption {
        description = "List of supported image providers, e.g., APPC,DOCKER.";
        default = [ ];
        type = types.listOf types.str;
      };

      imageProvisionerBackend = mkOption {
        description = ''
          Strategy for provisioning container rootfs from images,
          e.g., aufs, bind, copy, overlay.
        '';
        default = "copy";
        type = types.str;
      };

      isolation = mkOption {
        description = ''
          Isolation mechanisms to use, e.g., posix/cpu,posix/mem, or
          cgroups/cpu,cgroups/mem, or network/port_mapping, or `gpu/nvidia` for nvidia
          specific gpu isolation.
        '';
        default = [ "posix/cpu" "posix/mem" ];
        type = types.listOf types.str;
      };

      master = mkOption {
        description = ''
          May be one of:
            zk://host1:port1,host2:port2,.../path
            zk://username:password@host1:port1,host2:port2,.../path
        '';
        type = types.str;
      };

      withHadoop = mkOption {
        description = "Add the HADOOP_HOME to the slave.";
        default = false;
        type = types.bool;
      };

      withDocker = mkOption {
        description = "Enable the docker containerizer.";
        default = config.virtualisation.docker.enable;
        type = types.bool;
      };

      dockerRegistry = mkOption {
        description = ''
          The default url for pulling Docker images.
          It could either be a Docker registry server url,
          or a local path in which Docker image archives are stored.
        '';
        default = null;
        type = types.nullOr (types.either types.str types.path);
      };

      workDir = mkOption {
        description = "The Mesos work directory.";
        default = "/var/lib/mesos/slave";
        type = types.str;
      };

      extraCmdLineOptions = mkOption {
        description = ''
          Extra command line options for Mesos Slave.

          See https://mesos.apache.org/documentation/latest/configuration/
        '';
        default = [ "" ];
        type = types.listOf types.str;
        example = [ "--gc_delay=3days" ];
      };

      logLevel = mkOption {
        description = ''
          The logging level used. Possible values:
            'INFO', 'WARNING', 'ERROR'
        '';
        default = "INFO";
        type = types.str;
      };

      attributes = mkOption {
        description = ''
          Machine attributes for the slave instance.

          Use caution when changing this; you may need to manually reset slave
          metadata before the slave can re-register.
        '';
        default = {};
        type = types.attrsOf types.str;
        example = { rack = "aa";
                    host = "aabc123";
                    os = "nixos"; };
      };

      executorEnvironmentVariables = mkOption {
        description = ''
          The environment variables that should be passed to the executor, and thus subsequently task(s).
        '';
        default = {
          PATH = "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin";
        };
        type = types.attrsOf types.str;
      };
    };

  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d '${cfg.workDir}' 0701 - - - -"
    ];
    systemd.services.mesos-slave = {
      description = "Mesos Slave";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ optionals cfg.withDocker [ "docker.service" ] ;
      path = [ pkgs.runtimeShellPackage ];
      serviceConfig = {
        ExecStart = ''
          ${pkgs.mesos}/bin/mesos-slave \
            --containerizers=${containerizersArg} \
            --image_providers=${imageProvidersArg} \
            --image_provisioner_backend=${cfg.imageProvisionerBackend} \
            --isolation=${isolationArg} \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} \
            ${optionalString (cfg.advertiseIp != null) "--advertise_ip=${cfg.advertiseIp}"} \
            ${optionalString (cfg.advertisePort  != null) "--advertise_port=${toString cfg.advertisePort}"} \
            --master=${cfg.master} \
            --work_dir=${cfg.workDir} \
            --logging_level=${cfg.logLevel} \
            ${attribsArg} \
            ${optionalString cfg.withHadoop "--hadoop-home=${pkgs.hadoop}"} \
            ${optionalString cfg.withDocker "--docker=${pkgs.docker}/libexec/docker/docker"} \
            ${optionalString (cfg.dockerRegistry != null) "--docker_registry=${cfg.dockerRegistry}"} \
            --executor_environment_variables=${lib.escapeShellArg (builtins.toJSON cfg.executorEnvironmentVariables)} \
            ${toString cfg.extraCmdLineOptions}
        '';
      };
    };
  };

}
