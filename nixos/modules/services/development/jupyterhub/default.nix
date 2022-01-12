{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jupyterhub;

  # https://github.com/jupyterhub/systemdspawner#root-access
  runAsRoot = cfg.spawner == "systemdspawner.SystemdSpawner";
  localProcess = elem cfg.spawner ["systemdspawner.SystemdSpawner" "sudospawner.SudoSpawner"];

  kernels = (pkgs.jupyter-kernel.create {
    definitions = if cfg.kernels != null
      then cfg.kernels
      else  pkgs.jupyter-kernel.default;
  });

  jupyterhubEnv = pkgs.python3.withPackages (p: [
    p.jupyterhub
  ] ++ optional (cfg.spawner == "sudospawner.SudoSpawner") p.sudospawner
    ++ optional (cfg.spawner == "systemdspawner.SystemdSpawner") p.jupyterhub-systemdspawner
    ++ optional (cfg.spawner == "dockerspawner.DockerSpawner") p.dockerspawner
    ++ optional (hasPrefix "oauthenticator." cfg.authentication) p.oauthenticator
    ++ cfg.jupyterhubExtraPackages p);

  sudospawnerCmd = pkgs.stdenv.mkDerivation {
    name = "sudospawner-with-runner";

    nativeBuildInputs = [ pkgs.python3.pkgs.wrapPython ];
    pythonPath = [ pkgs.python3.pkgs.sudospawner ];

    buildCommand = ''
      mkdir -p $out/bin

      cat >$out/bin/jupyterhub-singleuser <<EOF
      #!${pkgs.stdenv.shell}
      export JUPYTER_PATH="${kernels}"
      exec ${jupyterlabEnv}/bin/jupyterhub-singleuser "\$@"
      EOF
      chmod +x $out/bin/jupyterhub-singleuser

      # sudospawner executes `jupyterhub-singleruser` binary from its directory.
      # Make an executable here so that it calls our script.
      cat >$out/bin/sudospawner <<EOF
      #!${pkgs.python3.interpreter}
      from sudospawner import mediator
      mediator.main()
      EOF
      chmod +x $out/bin/sudospawner

      wrapPythonProgramsIn $out/bin "$pythonPath"
    '';
  };

  jupyterlabEnv = pkgs.python3.withPackages (p: [
    p.jupyterhub
    p.jupyterlab
  ] ++ cfg.jupyterlabExtraPackages p);

  jupyterhubConfig = pkgs.writeText "jupyterhub_config.py" ''
    c.JupyterHub.bind_url = "http://${cfg.host}:${toString cfg.port}"

    c.JupyterHub.authenticator_class = "${cfg.authentication}"
    c.JupyterHub.spawner_class = "${cfg.spawner}"

    c.Spawner.default_url = '/lab'

    ${optionalString (cfg.spawner == "sudospawner.SudoSpawner") ''
      c.SudoSpawner.sudospawner_path = "${sudospawnerCmd}/bin/sudospawner";
    ''}
    ${optionalString (cfg.spawner == "systemdspawner.SystemdSpawner") ''
      c.SystemdSpawner.cmd = "${jupyterlabEnv}/bin/jupyterhub-singleuser"
      c.SystemdSpawner.environment = {
        'JUPYTER_PATH': '${kernels}'
      }
    ''}
    ${optionalString (cfg.spawner == "dockerspawner.DockerSpawner") ''
      import socket
      import fcntl
      import struct
      from pathlib import Path

      # Make JupyterHub accessible from Docker containers.
      def get_ip_address(ifname):
          s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
          try:
              return socket.inet_ntoa(fcntl.ioctl(
                  s.fileno(),
                  0x8915, # SIOCGIFADDR
                  struct.pack(b'256s', ifname[:15].encode('ascii'))
              )[20:24])
          finally:
              s.close()

      c.JupyterHub.hub_ip = get_ip_address('docker0')

      # Create user home directory.
      def create_dir_hook(spawner):
          user_home = Path('/var/lib/jupyterhub/user_data/') / spawner.escaped_name
          if not user_home.exists():
              user_home.mkdir()
              shared_data = user_home / 'shared_data'
              if not shared_data.exists():
                shared_data.mkdir()

      c.DockerSpawner.pre_spawn_hook = create_dir_hook

      c.DockerSpawner.volumes = {
        '/var/lib/jupyterhub/user_data/{username}': '/home/jovyan',
        '/var/lib/jupyterhub/shared_envs': '/opt/conda/envs',
        '/var/lib/jupyterhub/shared_config': '/usr/local/share/jupyter',
        '/var/lib/jupyterhub/shared_data': '/home/jovyan/shared_data',
      }
    ''}

    ${cfg.extraConfig}
  '';

  preStart = pkgs.writeScript "docker-pre-start" ''
    #!${pkgs.stdenv.shell}

    ${optionalString (cfg.spawner == "dockerspawner.DockerSpawner") ''
      # Remove old images (so they are updated).
      docker rm $(docker ps --filter status=exited --filter name=jupyter -q) || true

      # Mounted directories need to have sticky group permission compatible with docker image users (uid 100).
      install -d -o jupyterhub -g jupyterhub -m 775 /var/lib/jupyterhub/{user_data,shared_envs,shared_config,shared_data}
      setfacl -d -m g:100:rwx /var/lib/jupyterhub/{user_data,shared_envs,shared_config,shared_data}
      setfacl -m g:100:rwx /var/lib/jupyterhub/{user_data,shared_envs,shared_config,shared_data}
    ''}
  '';

in {
  meta.maintainers = with maintainers; [ costrouc ];

  options.services.jupyterhub = {
    enable = mkEnableOption "JupyterHub development server";

    authentication = mkOption {
      type = types.str;
      default = "jupyterhub.auth.PAMAuthenticator";
      description = ''
        JupyterHub authentication to use.

        There are many authenticators available including: oauth, pam,
        ldap, kerberos, etc.

        We support <literal>jupyterhub.auth.PAMAuthenticator</literal> and
        authenticators provided by <literal>oauthenticator</literal> package.
        Other authenticators require adding necessary packages and possibly
        extra configuration.
      '';
    };

    spawner = mkOption {
      type = types.str;
      default = "sudospawner.SudoSpawner";
      description = ''
        JupyterHub spawner to use.

        There are many spawners available including: local process,
        sudo, systemd, docker, kubernetes, yarn, batch, etc.

        We support <literal>sudospawner</literal>,
        <literal>systemdspawner</literal> and <literal>dockerspawner</literal>
        spawners. Other spawners require adding necessary packages and possibly
        extra configuration.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Extra contents appended to the JupyterHub configuration.

        JupyterHub configuration is a normal python file using
        <link xlink:href="https://jupyterhub.readthedocs.io/en/stable/getting-started/config-basics.html">Traitlets</link>.
        The base configuration of this module was designed to have sane
        defaults for configuration but you can override anything since this is
        a Python file.
      '';
      example = ''
        c.SystemdSpawner.mem_limit = '8G'
        c.SystemdSpawner.cpu_limit = 2.0
      '';
    };

    jupyterhubExtraPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = p: with p; [
        jupyterhub-systemdspawner
      ];
      defaultText = literalExpression ''
        p: with p; [
          jupyterhub-systemdspawner
        ]
      '';
      description = ''
        Extra Python packages in JupyterHub environment.

        Customizing will affect the packages available in the hub and
        proxy. This will allow packages to be available for the
        extraConfig that you may need. This will not normally need to
        be changed.
      '';
    };

    jupyterlabExtraPackages = mkOption {
      type = types.functionTo (types.listOf types.package);
      default = p: [];
      defaultText = literalExpression "p: with p; []";
      description = ''
        Extra Python packages in JupyterLab environment.

        Customizing will affect the packages available in the
        JupyterLab server and the default kernel provided. This is the
        way to customize the jupyterlab extensions and jupyter
        notebook extensions. This will not normally need to
        be changed.

        This has no effect if a non-local process spawner is used, such as
        Docker spawner.
      '';
    };

    kernels = mkOption {
      type = types.nullOr (types.attrsOf(types.submodule (import ../jupyter/kernel-options.nix {
        inherit lib;
      })));

      default = null;
      example = literalExpression ''
        {
          python3 = let
            env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                    ipykernel
                    pandas
                    scikit-learn
                  ]));
          in {
            displayName = "Python 3 for machine learning";
            argv = [
              "''${env.interpreter}"
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
            logo32 = "''${env}/''${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            logo64 = "''${env}/''${env.sitePackages}/ipykernel/resources/logo-64x64.png";
          };
        }
      '';
      description = ''
        Declarative kernel configuration.

        Kernels can be declared in any language that supports and has
        the required dependencies to communicate with a jupyter server.
        In python's case, it means that ipykernel package must always be
        included in the list of packages of the targeted environment.

        This has no effect if a non-default spawner is used.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = ''
        Port number JupyterHub will be listening on.
      '';
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = ''
        Bind IP JupyterHub will be listening on.
      '';
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "jupyterhub" "jupyterhubEnv" ] ''
      Please use `services.jupyterhub.jupyterhubExtraPackages` instead!
    '')
    (mkRemovedOptionModule [ "services" "jupyterhub" "jupyterlabEnv" ] ''
      Please use `services.jupyterhub.jupyterlabExtraPackages` instead!
    '')
    (mkRemovedOptionModule [ "services" "jupyterhub" "stateDirectory" ] ''
      `/var/lib/jupyterlab` is always used as the state directory now.
    '')
  ];

  config = mkIf cfg.enable {
    systemd.services.jupyterhub = {
      description = "JupyterHub development server";

      after = [ "network.target" ] ++ optional (cfg.spawner == "dockerspawner.DockerSpawner") "docker.service";
      wantedBy = [ "multi-user.target" ];

      path =
        optional (cfg.spawner == "sudospawner.SudoSpawner") "/run/wrappers"
        ++ optionals (cfg.spawner == "dockerspawner.DockerSpawner") [
          pkgs.acl
          pkgs.docker
        ];

      serviceConfig = {
        Restart = "always";
        ExecStart = "${jupyterhubEnv}/bin/jupyterhub --config ${jupyterhubConfig}";
        ExecStartPre = "+${preStart}";
        User = mkIf (!runAsRoot) "jupyterhub";
        Group = mkIf (!runAsRoot) "jupyterhub";
        StateDirectory = "jupyterhub";
        WorkingDirectory = "/var/lib/jupyterhub";
      };
    };

    security.sudo = mkIf (cfg.spawner == "sudospawner.SudoSpawner") {
      enable = true;
      extraConfig = ''
        Cmnd_Alias JUPYTER_CMD = ${sudospawnerCmd}/bin/sudospawner
        jupyterhub ALL=(%users) NOPASSWD:JUPYTER_CMD
      '';
    };

    virtualisation.docker = mkIf (cfg.spawner == "dockerspawner.DockerSpawner") {
      enable = true;
      # Needed to get interface IP address.
      enableOnBoot = true;
    };

    users.users.jupyterhub = mkIf (!runAsRoot) {
      extraGroups =
        optional (cfg.authentication == "jupyterhub.auth.PAMAuthenticator") "shadow"
        ++ optional (cfg.spawner == "dockerspawner.DockerSpawner") "docker";
      group = "jupyterhub";
      home = "/var/lib/jupyterhub";
      isSystemUser = true;
    };

    users.groups.jupyterhub = mkIf (!runAsRoot) {};
  };
}
