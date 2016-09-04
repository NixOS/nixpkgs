{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.services.lighttpd.inginious;
  inginious = pkgs.inginious;
  execName = "inginious-${if cfg.useLTI then "lti" else "webapp"}";

  inginiousConfigFile = if cfg.configFile != null then cfg.configFile else pkgs.writeText "inginious.yaml" ''
    # Backend; can be:
    # - "local" (run containers on the same machine)
    # - "remote" (connect to distant docker daemon and auto start agents) (choose this if you use boot2docker)
    # - "remote_manual" (connect to distant and manually installed agents)
    backend: "${cfg.backendType}"

    ## TODO (maybe): Add an option for the "remote" backend in this NixOS module.
    # List of remote docker daemon to which the backend will try
    # to connect (backend: remote only)
    #docker_daemons:
    #  - # Host of the docker daemon *from the webapp*
    #    remote_host: "some.remote.server"
    #    # Port of the distant docker daemon *from the webapp*
    #    remote_docker_port: "2375"
    #    # A mandatory port used by the backend and the agent that will be automatically started.
    #    # Needs to be available on the remote host, and to be open in the firewall.
    #    remote_agent_port: "63456"
    #    # Does the remote docker requires tls? Defaults to false.
    #    # Parameter can be set to true or path to the certificates
    #    #use_tls: false
    #    # Link to the docker daemon *from the host that runs the docker daemon*. Defaults to:
    #    #local_location: "unix:///var/run/docker.sock"
    #    # Path to the cgroups "mount" *from the host that runs the docker daemon*. Defaults to:
    #    #cgroups_location: "/sys/fs/cgroup"
    #    # Name that will be used to reference the agent
    #    #"agent_name": "inginious-agent"

    # List of remote agents to which the backend will try
    # to connect (backend: remote_manual only)
    # Example:
    #agents:
    #  - host: "192.168.59.103"
    #    port: 5001
    agents:
    ${lib.concatMapStrings (agent:
      "  - host: \"${agent.host}\"\n" +
      "    port: ${agent.port}\n"
    ) cfg.remoteAgents}

    # Location of the task directory
    tasks_directory: "${cfg.tasksDirectory}"

    # Super admins: list of user names that can do everything in the backend
    superadmins:
    ${lib.concatMapStrings (x: "  - \"${x}\"\n") cfg.superadmins}

    # Aliases for containers
    # Only containers listed here can be used by tasks
    containers:
    ${lib.concatStrings (lib.mapAttrsToList (name: fullname:
      "  ${name}: \"${fullname}\"\n"
    ) cfg.containers)}

    # Use single minified javascript file (production) or multiple files (dev) ?
    use_minified_js: true

    ## TODO (maybe): Add NixOS options for these parameters.

    # MongoDB options
    #mongo_opt:
    #    host: localhost
    #    database: INGInious

    # Disable INGInious?
    #maintenance: false

    #smtp:
    #    sendername: 'INGInious <no-reply@inginious.org>'
    #    host: 'smtp.gmail.com'
    #    port: 587
    #    username: 'configme@gmail.com'
    #    password: 'secret'
    #    starttls: True

    ## NixOS extra config

    ${cfg.extraConfig}
  '';
in
{
  options.services.lighttpd.inginious = {
    enable = mkEnableOption  "INGInious, an automated code testing and grading system.";

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = literalExample ''pkgs.writeText "configuration.yaml" "# custom config options ...";'';
      description = ''The path to an INGInious configuration file.'';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      example = ''
        # Load the dummy auth plugin.
        plugins:
          - plugin_module: inginious.frontend.webapp.plugins.auth.demo_auth
            users:
              # register the user "test" with the password "someverycomplexpassword"
              test: someverycomplexpassword
      '';
      description = ''Extra option in YaML format, to be appended to the config file.'';
    };

    tasksDirectory = mkOption {
      type = types.path;
      default = "${inginious}/lib/python2.7/site-packages/inginious/tasks";
      example = "/var/lib/INGInious/tasks";
      description = ''
        Path to the tasks folder.
        Defaults to the provided test tasks folder (readonly).
      '';
    };

    useLTI = mkOption {
      type = types.bool;
      default = false;
      description = ''Whether to start the LTI frontend in place of the webapp.'';
    };

    superadmins = mkOption {
      type = types.uniq (types.listOf types.str);
      default = [ "admin" ];
      example = [ "john" "pepe" "emilia" ];
      description = ''List of user logins allowed to administrate the whole server.'';
    };

    containers = mkOption {
      type = types.attrsOf types.str;
      default = {
          default = "ingi/inginious-c-default";
      };
      example = {
        default = "ingi/inginious-c-default";
        sekexe  = "ingi/inginious-c-sekexe";
        java    = "ingi/inginious-c-java";
        oz      = "ingi/inginious-c-oz";
        pythia1compat = "ingi/inginious-c-pythia1compat";
      };
      description = ''
        An attrset describing the required containers
        These containers will be available in INGInious using their short name (key)
        and will be automatically downloaded before INGInious starts.
      '';
    };

    hostPattern = mkOption {
      type = types.str;
      default = "^inginious.";
      example = "^inginious.mydomain.xyz$";
      description = ''
        The domain that serves INGInious.
        INGInious uses absolute paths which makes it difficult to relocate in its own subdir.
        The default configuration will serve INGInious when the server is accessed with a hostname starting with "inginious.".
        If left blank, INGInious will take the precedence over all the other lighttpd sites, which is probably not what you want.
      '';
    };

    backendType = mkOption {
      type = types.enum [ "local" "remote_manual" ]; # TODO: support backend "remote"
      default = "local";
      description = ''
        Select how INGINious accesses to grading containers.
        The default "local" option ensures that Docker is started and provisioned.
        Fore more information, see http://inginious.readthedocs.io/en/latest/install_doc/config_reference.html
        Not all backends are supported. Use services.inginious.configFile for full flexibility.
      '';
    };

    remoteAgents = mkOption {
      type = types.listOf (types.attrsOf types.str);
      default = [];
      example = [ { host = "192.0.2.25"; port = "1345"; } ];
      description = ''A list of remote agents, used only when services.inginious.backendType is "remote_manual".'';
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      # For a local install, we need docker.
      (mkIf (cfg.backendType == "local") {
        virtualisation.docker = {
          enable = true;
          # We need docker to listen on port 2375.
          extraOptions = "-H tcp://127.0.0.1:2375 -H unix:///var/run/docker.sock";
          storageDriver = mkDefault "overlay";
          socketActivation = false;
        };

        users.extraUsers."lighttpd".extraGroups = [ "docker" ];

        # Ensure that docker has pulled the required images.
        systemd.services.inginious-prefetch = {
          script = let
            images = lib.unique (
              [ "centos" "ingi/inginious-agent" ]
              ++ lib.mapAttrsToList (_: image: image) cfg.containers
            );
          in lib.concatMapStrings (image: ''
            ${pkgs.docker}/bin/docker pull ${image}
          '') images;

          serviceConfig.Type = "oneshot";
          wants = [ "docker.service" ];
          after = [ "docker.service" ];
          wantedBy = [ "lighttpd.service" ];
          before = [ "lighttpd.service" ];
        };
      })

      # Common
      {
        # To access inginous tools (like inginious-test-task)
        environment.systemPackages = [ inginious ];

        services.mongodb.enable = true;

        services.lighttpd.enable = true;
        services.lighttpd.enableModules = [ "mod_access" "mod_alias" "mod_fastcgi" "mod_redirect" "mod_rewrite" ];
        services.lighttpd.extraConfig = ''
          $HTTP["host"] =~ "${cfg.hostPattern}" {
            fastcgi.server = ( "/${execName}" =>
              ((
                "socket" => "/run/lighttpd/inginious-fastcgi.socket",
                "bin-path" => "${inginious}/bin/${execName} --config=${inginiousConfigFile}",
                "max-procs" => 1,
                "bin-environment" => ( "REAL_SCRIPT_NAME" => "" ),
                "check-local" => "disable"
              ))
            )
            url.rewrite-once = (
              "^/.well-known/.*" => "$0",
              "^/static/.*" => "$0",
              "^/.*$" => "/${execName}$0",
              "^/favicon.ico$" => "/static/common/favicon.ico",
            )
            alias.url += (
              "/static/webapp/" => "${inginious}/lib/python2.7/site-packages/inginious/frontend/webapp/static/",
              "/static/common/" => "${inginious}/lib/python2.7/site-packages/inginious/frontend/common/static/"
            )
          }
        '';

        systemd.services.lighttpd.preStart = ''
          mkdir -p /run/lighttpd
          chown lighttpd.lighttpd /run/lighttpd
        '';

        systemd.services.lighttpd.wants = [ "mongodb.service" "docker.service" ];
        systemd.services.lighttpd.after = [ "mongodb.service" "docker.service" ];
      }
    ]);
}
