{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jupyter;

  # NOTE: We don't use top-level jupyter because we don't
  # want to pass in JUPYTER_PATH but use .environment instead,
  # saving a rebuild.
  package = pkgs.python3.pkgs.notebook;

  kernels = (pkgs.jupyter-kernel.create  {
    definitions = if cfg.kernels != null
      then cfg.kernels
      else  pkgs.jupyter-kernel.default;
  });

  notebookConfig = pkgs.writeText "jupyter_config.py" ''
    ${cfg.notebookConfig}

    c.NotebookApp.password = ${cfg.password}
  '';

in {
  meta.maintainers = with maintainers; [ aborsu ];

  options.services.jupyter = {
    enable = mkEnableOption "Jupyter development server";

    ip = mkOption {
      type = types.str;
      default = "localhost";
      description = ''
        IP address Jupyter will be listening on.
      '';
    };

    port = mkOption {
      type = types.int;
      default = 8888;
      description = ''
        Port number Jupyter will be listening on.
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
      default = "jupyter";
      description = ''
        Name of the user used to run the jupyter service.
        For security reason, jupyter should really not be run as root.
        If not set (jupyter), the service will create a jupyter user with appropriate settings.
      '';
      example = "aborsu";
    };

    group = mkOption {
      type = types.str;
      default = "jupyter";
      description = ''
        Name of the group used to run the jupyter service.
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

    notebookConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Raw jupyter config.
      '';
    };

    kernels = mkOption {
      type = types.nullOr (types.attrsOf(types.submodule (import ./kernel-options.nix {
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
      dependencies to communicate with a jupyter server.
      In python's case, it means that ipykernel package must always be included in
      the list of packages of the targeted environment.
      ";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable  {
      systemd.services.jupyter = {
        description = "Jupyter development server";

        wantedBy = [ "multi-user.target" ];

        # TODO: Patch notebook so we can explicitly pass in a shell
        path = [ pkgs.bash ]; # needed for sh in cell magic to work

        environment = {
          JUPYTER_PATH = toString kernels;
        };

        serviceConfig = {
          Restart = "always";
          ExecStart = ''${package}/bin/jupyter-notebook \
            --no-browser \
            --ip=${cfg.ip} \
            --port=${toString cfg.port} --port-retries 0 \
            --notebook-dir=${cfg.notebookDir} \
            --NotebookApp.config_file=${notebookConfig}
          '';
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "~";
        };
      };
    })
    (mkIf (cfg.enable && (cfg.group == "jupyter")) {
      users.groups.jupyter = {};
    })
    (mkIf (cfg.enable && (cfg.user == "jupyter")) {
      users.extraUsers.jupyter = {
        extraGroups = [ cfg.group ];
        home = "/var/lib/jupyter";
        createHome = true;
        useDefaultShell = true; # needed so that the user can start a terminal.
      };
    })
  ];
}
