{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jupyterhub;

  kernels = (pkgs.jupyter-kernel.create  {
    definitions = if cfg.kernels != null
      then cfg.kernels
      else  pkgs.jupyter-kernel.default;
  });

  jupyterhubConfig = pkgs.writeText "jupyterhub_config.py" ''
    c.JupyterHub.bind_url = "http://${cfg.host}:${toString cfg.port}"

    c.JupyterHub.authenticator_class = "${cfg.authentication}"
    c.JupyterHub.spawner_class = "${cfg.spawner}"

    c.SystemdSpawner.default_url = '/lab'
    c.SystemdSpawner.cmd = "${cfg.jupyterlabEnv}/bin/jupyterhub-singleuser"
    c.SystemdSpawner.environment = {
      'JUPYTER_PATH': '${kernels}'
    }

    ${cfg.extraConfig}
  '';
in {
  meta.maintainers = with maintainers; [ costrouc ];

  options.services.jupyterhub = {
    enable = mkEnableOption "Jupyterhub development server";

    authentication = mkOption {
      type = types.str;
      default = "jupyterhub.auth.PAMAuthenticator";
      description = lib.mdDoc ''
        Jupyterhub authentication to use

        There are many authenticators available including: oauth, pam,
        ldap, kerberos, etc.
      '';
    };

    spawner = mkOption {
      type = types.str;
      default = "systemdspawner.SystemdSpawner";
      description = lib.mdDoc ''
        Jupyterhub spawner to use

        There are many spawners available including: local process,
        systemd, docker, kubernetes, yarn, batch, etc.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Extra contents appended to the jupyterhub configuration

        Jupyterhub configuration is a normal python file using
        Traitlets. https://jupyterhub.readthedocs.io/en/stable/getting-started/config-basics.html. The
        base configuration of this module was designed to have sane
        defaults for configuration but you can override anything since
        this is a python file.
      '';
      example = ''
        c.SystemdSpawner.mem_limit = '8G'
        c.SystemdSpawner.cpu_limit = 2.0
      '';
    };

    jupyterhubEnv = mkOption {
      type = types.package;
      default = pkgs.python3.withPackages (p: with p; [
        jupyterhub
        jupyterhub-systemdspawner
      ]);
      defaultText = literalExpression ''
        pkgs.python3.withPackages (p: with p; [
          jupyterhub
          jupyterhub-systemdspawner
        ])
      '';
      description = lib.mdDoc ''
        Python environment to run jupyterhub

        Customizing will affect the packages available in the hub and
        proxy. This will allow packages to be available for the
        extraConfig that you may need. This will not normally need to
        be changed.
      '';
    };

    jupyterlabEnv = mkOption {
      type = types.package;
      default = pkgs.python3.withPackages (p: with p; [
        jupyterhub
        jupyterlab
      ]);
      defaultText = literalExpression ''
        pkgs.python3.withPackages (p: with p; [
          jupyterhub
          jupyterlab
        ])
      '';
      description = lib.mdDoc ''
        Python environment to run jupyterlab

        Customizing will affect the packages available in the
        jupyterlab server and the default kernel provided. This is the
        way to customize the jupyterlab extensions and jupyter
        notebook extensions. This will not normally need to
        be changed.
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
      description = lib.mdDoc ''
        Declarative kernel config

        Kernels can be declared in any language that supports and has
        the required dependencies to communicate with a jupyter server.
        In python's case, it means that ipykernel package must always be
        included in the list of packages of the targeted environment.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8000;
      description = lib.mdDoc ''
        Port number Jupyterhub will be listening on
      '';
    };

    host = mkOption {
      type = types.str;
      default = "0.0.0.0";
      description = lib.mdDoc ''
        Bind IP JupyterHub will be listening on
      '';
    };

    stateDirectory = mkOption {
      type = types.str;
      default = "jupyterhub";
      description = lib.mdDoc ''
        Directory for jupyterhub state (token + database)
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable  {
      systemd.services.jupyterhub = {
        description = "Jupyterhub development server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          Restart = "always";
          ExecStart = "${cfg.jupyterhubEnv}/bin/jupyterhub --config ${jupyterhubConfig}";
          User = "root";
          StateDirectory = cfg.stateDirectory;
          WorkingDirectory = "/var/lib/${cfg.stateDirectory}";
        };
      };
    })
  ];
}
