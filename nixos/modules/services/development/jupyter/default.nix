{
  config,
  lib,
  pkgs,
  options,
  ...
}:
let

  cfg = config.services.jupyter;

  package = pkgs.python3.withPackages (
    ps:
    [
      cfg.package
    ]
    ++ cfg.extraPackages
  );

  kernels = (
    pkgs.jupyter-kernel.create {
      definitions = if cfg.kernels != null then cfg.kernels else pkgs.jupyter-kernel.default;
    }
  );

  notebookConfig = pkgs.writeText "jupyter_server_config.py" ''
    ${cfg.notebookConfig}
    c.ServerApp.password = "${cfg.password}"
  '';

in
{
  meta.maintainers = with lib.maintainers; [
    aborsu
    b-m-f
  ];

  options.services.jupyter = {
    enable = lib.mkEnableOption "Jupyter development server";

    ip = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        IP address Jupyter will be listening on.
      '';
    };

    package = lib.mkPackageOption pkgs [
      "python3"
      "pkgs"
      "jupyter"
    ] { };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression ''
        [
          pkgs.python3.pkgs.nbconvert
          pkgs.python3.pkgs.playwright
        ]
      '';
      description = "Extra packages to be available in the jupyter runtime environment";
    };
    extraEnvironmentVariables = lib.mkOption {
      description = "Extra environment variables to be set in the runtime context of jupyter notebook";
      default = { };
      example = lib.literalExpression ''
        {
          PLAYWRIGHT_BROWSERS_PATH = "''${pkgs.playwright-driver.browsers}";
          PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
        }
      '';
      inherit (options.environment.variables) type apply;
    };

    command = lib.mkOption {
      type = lib.types.str;
      default = "jupyter notebook";
      example = "jupyter lab";
      description = ''
        Which command the service runs. Note that not all jupyter packages
        have all commands, e.g. `jupyter lab` isn't present in the `notebook` package.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8888;
      description = ''
        Port number Jupyter will be listening on.
      '';
    };

    notebookDir = lib.mkOption {
      type = lib.types.str;
      default = "~/";
      description = ''
        Root directory for notebooks.
      '';
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "jupyter";
      description = ''
        Name of the user used to run the jupyter service.
        For security reason, jupyter should really not be run as root.
        If not set (jupyter), the service will create a jupyter user with appropriate settings.
      '';
      example = "aborsu";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "jupyter";
      description = ''
        Name of the group used to run the jupyter service.
        Use this if you want to create a group of users that are able to view the notebook directory's content.
      '';
      example = "users";
    };

    password = lib.mkOption {
      type = lib.types.str;
      description = ''
        Password to use with notebook.
        Can be generated following: <https://jupyter-server.readthedocs.io/en/stable/operators/public-server.html#preparing-a-hashed-password>
      '';
      example = "argon2:$argon2id$v=19$m=10240,t=10,p=8$48hF+vTUuy1LB83/GzNhUg$J1nx4jPWD7PwOJHs5OtDW8pjYK2s0c1R3rYGbSIKB54";
    };

    notebookConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Raw jupyter config.
        Please use the password configuration option to set a password instead of passing it in here.
      '';
    };

    kernels = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.attrsOf (
          lib.types.submodule (
            import ./kernel-options.nix {
              inherit lib pkgs;
            }
          )
        )
      );

      default = null;
      example = lib.literalExpression ''
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
      description = ''
        Declarative kernel config.

        Kernels can be declared in any language that supports and has the required
        dependencies to communicate with a jupyter server.
        In python's case, it means that ipykernel package must always be included in
        the list of packages of the targeted environment.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      systemd.services.jupyter = {
        description = "Jupyter development server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        # TODO: Patch notebook so we can explicitly pass in a shell
        path = [ pkgs.bash ]; # needed for sh in cell magic to work

        environment = {
          JUPYTER_PATH = toString kernels;
        }
        // cfg.extraEnvironmentVariables;

        serviceConfig = {
          Restart = "always";
          ExecStart = ''
            ${package}/bin/${cfg.command} \
                        --no-browser \
                        --ip=${cfg.ip} \
                        --port=${toString cfg.port} --port-retries 0 \
                        --notebook-dir=${cfg.notebookDir} \
                        --JupyterApp.config_file=${notebookConfig}

          '';
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = "~";
        };
      };
    })
    (lib.mkIf (cfg.enable && (cfg.group == "jupyter")) {
      users.groups.jupyter = { };
    })
    (lib.mkIf (cfg.enable && (cfg.user == "jupyter")) {
      users.extraUsers.jupyter = {
        inherit (cfg) group;
        home = "/var/lib/jupyter";
        createHome = true;
        isSystemUser = true;
        useDefaultShell = true; # needed so that the user can start a terminal.
      };
    })
  ];
}
