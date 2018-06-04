{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jupyterlab;


  kernels = (pkgs.jupyterKernels.create  {
    kernelDefinitions = if cfg.kernels != null
      then cfg.kernels
      else  pkgs.jupyterKernels.defaultKernelDefinition;
  });

  labConfig = pkgs.writeText "jupyterlab_config.py" ''
    ${cfg.notebookConfig}
  '';

  notebookConfig = pkgs.writeText "jupyter_config.py" ''
    ${cfg.notebookConfig}

    c.NotebookApp.password = ${cfg.password}
  '';

in {
  meta.maintainers = with maintainers; [ aborsu ];

  options.services.jupyterlab = {
    enable = mkEnableOption "Jupyterlab development server";

    ip = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        IP address Jupyterlab will be listening on.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8888;
      description = ''
        Port number Jupyterlab will be listening on.
      '';
    };

    notebookDir = mkOption {
      type = types.str;
      default = "~/";
      description = ''
        Root directory for notebooks.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "jupyterlab";
      description = ''
        Name of the user used to run the jupyterlab service.
        For security reason, jupyterlab should really not be run as root.
        If not set (jupyterlab), the service will create a jupyterlab user with appropriate settings.
      '';
      example = "aborsu";
    };

    group = mkOption {
      type = types.str;
      default = "jupyterlab";
      description = ''
        Name of the group used to run the jupyterlab service.
        Use this if you want to create a group of users that are able to view the notebook directory's content.
      '';
      example = "users";
    };

    password = mkOption {
      type = types.str;
      description = ''
        Password to use with notebook.
        Can be generated using:
          In [1]: from notebook.auth import passwd
          In [2]: passwd('test')
          Out[2]: 'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'
          NOTE: you need to keep the single quote inside the nix string.
        Or you can use a python oneliner:
          "open('/path/secret_file', 'r', encoding='utf8').read().strip()"
        It will be interpreted at the end of the notebookConfig.
      '';
      example = [
        "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'"
        "open('/path/secret_file', 'r', encoding='utf8').read().strip()"
      ];
    };

    labConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Raw jupyterlab config.
      '';
    };
      
    notebookConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Raw jupyter notebook config.
      '';
    };

    kernels = mkOption {
      type = types.nullOr (types.attrsOf(types.submodule (import ../jupyter/kernel-options.nix {
        inherit lib;
      })));

      default = null;
      example = literalExample ''
        {
          python3 = let
            env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
                    ipykernel
                    pandas
                    scikitlearn
                  ]));
          in {
            displayName = "Python 3 for machine learning";
            argv = [
              "$ {env.interpreter}"
              "-m"
              "ipykernel_launcher"
              "-f"
              "{connection_file}"
            ];
            language = "python";
            logo32 = "$ {env.sitePackages}/ipykernel/resources/logo-32x32.png";
            logo64 = "$ {env.sitePackages}/ipykernel/resources/logo-64x64.png";
          };
        }
      '';
      description = "Declarative kernel config

      Kernels can be declared in any language that supports and has the required
      dependencies to communicate with a jupyterlab server.
      In python's case, it means that ipykernel package must always be included in
      the list of packages of the targeted environment.
      ";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable  {
      systemd.services.jupyterlab = {
        description = "Jupyterlab development server";

        wantedBy = [ "multi-user.target" ];

        path = [
          pkgs.nodejs
          pkgs.bash
        ];

        environment = {
          JUPYTERLAB_DIR = toString kernels;
        };

        serviceConfig = {
          Restart = "always";
          ExecStart = ''${pkgs.python3.pkgs.jupyterlab}/bin/jupyter-lab \
            --no-browser \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} --port-retries 0 \
            --notebook-dir=${cfg.notebookDir} \
            --NotebookApp.config_file=${notebookConfig} \
            --config=${labConfig}
          '';
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "~";
          PermissionsStartOnly = true;
        };
        
        preStart = ''
          if [ ! -d ${cfg.notebookDir} ]; then
            mkdir -p ${cfg.notebookDir}
          fi
          chown ${cfg.user}:${cfg.group} ${cfg.notebookDir}
        '';
        
      };
    })
    (mkIf (cfg.enable && (cfg.group == "jupyterlab")) {
      users.groups.jupyterlab = {};
    })
    (mkIf (cfg.enable && (cfg.user == "jupyterlab")) {
      users.extraUsers.jupyterlab = {
        extraGroups = [ cfg.group ];
        home = "/var/lib/jupyterlab";
        createHome = true;
        useDefaultShell = true; # needed so that the user can start a terminal.
      };
    })
  ];
}
