{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jupyter;

  package = cfg.package;

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
    enable = mkEnableOption (lib.mdDoc "Jupyter development server");

    ip = mkOption {
      type = types.str;
      default = "localhost";
      description = lib.mdDoc ''
        IP address Jupyter will be listening on.
      '';
    };

    package = mkOption {
      type = types.package;
      # NOTE: We don't use top-level jupyter because we don't
      # want to pass in JUPYTER_PATH but use .environment instead,
      # saving a rebuild.
      default = pkgs.python3.pkgs.notebook;
      defaultText = literalExpression "pkgs.python3.pkgs.notebook";
      description = lib.mdDoc ''
        Jupyter package to use.
      '';
    };

    command = mkOption {
      type = types.str;
      default = "jupyter-notebook";
      example = "jupyter-lab";
      description = lib.mdDoc ''
        Which command the service runs. Note that not all jupyter packages
        have all commands, e.g. jupyter-lab isn't present in the default package.
       '';
    };

    port = mkOption {
      type = types.int;
      default = 8888;
      description = lib.mdDoc ''
        Port number Jupyter will be listening on.
      '';
    };

    notebookDir = mkOption {
      type = types.str;
      default = "~/";
      description = lib.mdDoc ''
        Root directory for notebooks.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "jupyter";
      description = lib.mdDoc ''
        Name of the user used to run the jupyter service.
        For security reason, jupyter should really not be run as root.
        If not set (jupyter), the service will create a jupyter user with appropriate settings.
      '';
      example = "aborsu";
    };

    group = mkOption {
      type = types.str;
      default = "jupyter";
      description = lib.mdDoc ''
        Name of the group used to run the jupyter service.
        Use this if you want to create a group of users that are able to view the notebook directory's content.
      '';
      example = "users";
    };

    password = mkOption {
      type = types.str;
      description = lib.mdDoc ''
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
      example = "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'";
    };

    notebookConfig = mkOption {
      type = types.lines;
      default = "";
      description = lib.mdDoc ''
        Raw jupyter config.
      '';
    };

    kernels = mkOption {
      type = types.nullOr (types.attrsOf(types.submodule (import ./kernel-options.nix {
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
            logo32 = "''${env.sitePackages}/ipykernel/resources/logo-32x32.png";
            logo64 = "''${env.sitePackages}/ipykernel/resources/logo-64x64.png";
            extraPaths = {
              "cool.txt" = pkgs.writeText "cool" "cool content";
            };
          };
        }
      '';
      description = lib.mdDoc ''
        Declarative kernel config.

        Kernels can be declared in any language that supports and has the required
        dependencies to communicate with a jupyter server.
        In python's case, it means that ipykernel package must always be included in
        the list of packages of the targeted environment.
      '';
    };
  };

  config = mkMerge [
    (mkIf cfg.enable  {
      systemd.services.jupyter = {
        description = "Jupyter development server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        # TODO: Patch notebook so we can explicitly pass in a shell
        path = [ pkgs.bash ]; # needed for sh in cell magic to work

        environment = {
          JUPYTER_PATH = toString kernels;
        };

        serviceConfig = {
          Restart = "always";
          ExecStart = ''${package}/bin/${cfg.command} \
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
        isSystemUser = true;
        useDefaultShell = true; # needed so that the user can start a terminal.
      };
    })
  ];
}
