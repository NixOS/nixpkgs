{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.ghorg;
  yaml = pkgs.formats.yaml { };

  hasInlineConfig =
    job:
    job.rawSettings != { }
    || builtins.any (value: value != null) [
      job.settings.scmType
      job.settings.cloneType
      job.settings.sshHostname
      job.settings.baseUrl
      job.settings.cloneProtocol
      job.settings.outputDir
      job.settings.concurrency
      job.settings.preserveScmHostname
      job.settings.preserveDir
      job.settings.skipArchived
      job.settings.skipForks
      job.settings.branch
      job.settings.cloneToPath
    ];

  renderJobSettings =
    job:
    let
      typedSettings =
        lib.optionalAttrs (job.settings.scmType != null) { GHORG_SCM_TYPE = job.settings.scmType; }
        // lib.optionalAttrs (job.settings.cloneType != null) { GHORG_CLONE_TYPE = job.settings.cloneType; }
        // lib.optionalAttrs (job.settings.sshHostname != null) {
          GHORG_SSH_HOSTNAME = job.settings.sshHostname;
        }
        // lib.optionalAttrs (job.settings.baseUrl != null) {
          GHORG_SCM_BASE_URL = job.settings.baseUrl;
        }
        // lib.optionalAttrs (job.settings.cloneProtocol != null) {
          GHORG_CLONE_PROTOCOL = job.settings.cloneProtocol;
        }
        // lib.optionalAttrs (job.settings.outputDir != null) { GHORG_OUTPUT_DIR = job.settings.outputDir; }
        // lib.optionalAttrs (job.settings.concurrency != null) {
          GHORG_CONCURRENCY = job.settings.concurrency;
        }
        // lib.optionalAttrs (job.settings.preserveScmHostname != null) {
          GHORG_PRESERVE_SCM_HOSTNAME = job.settings.preserveScmHostname;
        }
        // lib.optionalAttrs (job.settings.preserveDir != null) {
          GHORG_PRESERVE_DIRECTORY_STRUCTURE = job.settings.preserveDir;
        }
        // lib.optionalAttrs (job.settings.skipArchived != null) {
          GHORG_SKIP_ARCHIVED = job.settings.skipArchived;
        }
        // lib.optionalAttrs (job.settings.skipForks != null) { GHORG_SKIP_FORKS = job.settings.skipForks; }
        // lib.optionalAttrs (job.settings.branch != null) { GHORG_BRANCH = job.settings.branch; }
        // {
          GHORG_ABSOLUTE_PATH_TO_CLONE_TO =
            if job.settings.cloneToPath != null then job.settings.cloneToPath else cfg.dataDir;
        };
    in
    typedSettings // job.rawSettings;

  jobConfigFile =
    name: job:
    if job.configFile != null then
      job.configFile
    else
      yaml.generate "ghorg-${name}.yaml" (renderJobSettings job);

  jobCommand =
    name: job:
    lib.escapeShellArgs (
      [ "ghorg" ]
      ++ job.args
      ++ [
        "--config"
        (jobConfigFile name job)
      ]
      ++ lib.optionals (job.tokenFile != null) [
        "--token"
        job.tokenFile
      ]
      ++ job.extraArgs
    );

  recloneConfig = yaml.generate "ghorg-reclone.yaml" (
    lib.mapAttrs (
      name: job:
      {
        cmd = jobCommand name job;
      }
      // lib.optionalAttrs (job.description != null) { description = job.description; }
      // lib.optionalAttrs (job.postExecScript != null) {
        post_exec_script = toString job.postExecScript;
      }
    ) cfg.jobs
  );
in
{
  options.services.ghorg = {
    enable = lib.mkEnableOption "ghorg mirror jobs managed through ghorg reclone";

    package = lib.mkPackageOption pkgs "ghorg" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "ghorg";
      description = "User account that runs ghorg.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "ghorg";
      description = "Primary group for the ghorg service.";
    };

    createUser = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to create the ghorg system user automatically.";
    };

    createGroup = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to create the ghorg system group automatically.";
    };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/ghorg";
      description = ''
        Working directory for ghorg and the default clone destination for jobs
        that do not override `settings.cloneToPath`.
      '';
    };

    dataDirMode = lib.mkOption {
      type = lib.types.str;
      default = "0750";
      example = "0700";
      description = "Permissions mode used when creating `dataDir` via systemd-tmpfiles.";
    };

    startAt = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "daily";
      description = ''
        Optional systemd timer schedule in `OnCalendar=` format. Leave `null`
        to manage execution manually.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Optional shared environment file for the ghorg reclone service. This is
        appropriate for GHORG_* variables that may be reused across multiple
        jobs.
      '';
    };

    jobs = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
            options = {
              description = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Optional description written into the generated reclone entry.";
              };

              postExecScript = lib.mkOption {
                type = lib.types.nullOr (lib.types.either lib.types.path lib.types.str);
                default = null;
                description = "Optional `post_exec_script` value for this reclone entry.";
              };

              args = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [
                  "clone"
                  name
                ];
                example = [
                  "clone"
                  "my-org"
                ];
                description = ''
                  ghorg subcommand and arguments for this job, excluding the
                  executable name. `--config` is appended automatically.
                '';
              };

              extraArgs = lib.mkOption {
                type = lib.types.listOf lib.types.str;
                default = [ ];
                example = [
                  "--preserve-dir"
                ];
                description = ''
                  Additional command-line arguments appended after `args`.
                  These override equivalent settings from `settings` or
                  `rawSettings`, because ghorg prefers CLI flags over `conf.yaml`.
                '';
              };

              configFile = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  Existing ghorg configuration file for this job. When set, the
                  module will not generate a config from `settings` or
                  `rawSettings`.
                '';
              };

              tokenFile = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "/run/agenix/ghorg-github-token";
                description = ''
                  Optional token file path appended as `--token` for this job.
                  Use this for per-provider secrets when a single shared
                  `environmentFile` is not appropriate.
                '';
              };

              settings = {
                scmType = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "github";
                  description = ''
                    Which provider to clone from, for example `github`,
                    `gitlab`, `gitea`, or `bitbucket`. This corresponds to the
                    `--scm` flag and defaults to `github` in ghorg.
                  '';
                };

                cloneType = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "user";
                  description = ''
                    Type of entity to clone, typically `user` or `org`. This
                    corresponds to `--clone-type` and is important for targets
                    like GitHub users, which otherwise default to org mode.
                  '';
                };

                sshHostname = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "github.com";
                  description = ''
                    Override the SSH hostname used in clone URLs. This is useful
                    when your `~/.ssh/config` defines aliases for the same SCM
                    provider. It only applies when `cloneProtocol = "ssh"`.
                  '';
                };

                baseUrl = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "https://gitlab.example.com";
                  description = ''
                    Override the SCM API base URL. This is intended for
                    self-hosted SCM instances such as self-hosted GitLab or
                    Gitea.
                  '';
                };

                cloneProtocol = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "ssh";
                  description = ''
                    Which protocol ghorg should use for clone URLs. ghorg
                    supports `https` or `ssh` and defaults to `https`.
                  '';
                };

                outputDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  example = "github";
                  description = ''
                    Subdirectory created under `cloneToPath`. ghorg clones into
                    `absolute_path_to_clone_to/output_dir/repo`; by default it
                    uses the org or user name you are cloning.
                  '';
                };

                concurrency = lib.mkOption {
                  type = lib.types.nullOr lib.types.ints.positive;
                  default = null;
                  description = ''
                    Maximum number of goroutines ghorg uses while cloning. The
                    upstream default is `25`.
                  '';
                };

                preserveScmHostname = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                  description = ''
                    Append the SCM hostname to `cloneToPath` so clones are
                    organized by provider host, for example
                    `/data/ghorg/github.com/...`.
                  '';
                };

                preserveDir = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                  description = ''
                    Preserve provider-specific directory structure instead of
                    flattening everything under one output directory. For GitLab
                    this keeps namespace paths such as `group/subgroup/repo`.
                  '';
                };

                skipArchived = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                  description = ''
                    Skip archived repositories. Upstream notes this currently
                    applies to GitHub, GitLab, and Gitea.
                  '';
                };

                skipForks = lib.mkOption {
                  type = lib.types.nullOr lib.types.bool;
                  default = null;
                  description = ''
                    Skip repositories that are forks. Upstream notes this
                    currently applies to GitHub, GitLab, and Gitea.
                  '';
                };

                branch = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Branch ghorg resets to and leaves checked out after sync.
                    When unset, ghorg uses the repository default branch and
                    falls back to `master` if no default branch is found.
                  '';
                };

                cloneToPath = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = ''
                    Absolute path where ghorg creates its clone directory tree.
                    Shell expansions do not work. When unset, this module uses
                    the service `dataDir`.
                  '';
                };
              };

              rawSettings = lib.mkOption {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
                example = {
                  GHORG_BITBUCKET_SERVER = true;
                };
                description = ''
                  Additional ghorg config keys written directly into the
                  generated `conf.yaml`. Use upstream `GHORG_*` key names here.
                  This layer overrides keys produced from `settings`.
                '';
              };
            };
          }
        )
      );
      default = { };
      description = ''
        Set of ghorg jobs. Each job is rendered into a dedicated config and a
        generated reclone entry. A single ordinary clone run is modeled as a
        single job.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = lib.hasPrefix "/" cfg.dataDir;
        message = "services.ghorg.dataDir must be an absolute path.";
      }
      {
        assertion = builtins.match "[0-7]{4}" cfg.dataDirMode != null;
        message = "services.ghorg.dataDirMode must be a four-digit octal mode string such as 0750.";
      }
      {
        assertion = cfg.environmentFile == null || lib.hasPrefix "/" cfg.environmentFile;
        message = "services.ghorg.environmentFile must be null or an absolute path.";
      }
      {
        assertion = cfg.jobs != { };
        message = "services.ghorg.jobs must define at least one job.";
      }
    ]
    ++ lib.flatten (
      lib.mapAttrsToList (name: job: [
        {
          assertion = job.args != [ ];
          message = "services.ghorg.jobs.${name}.args must not be empty.";
        }
        {
          assertion = lib.head job.args == "clone";
          message = "services.ghorg.jobs.${name}.args must begin with `clone` for ghorg reclone.";
        }
        {
          assertion = job.configFile == null || lib.hasPrefix "/" job.configFile;
          message = "services.ghorg.jobs.${name}.configFile must be null or an absolute path.";
        }
        {
          assertion = job.tokenFile == null || lib.hasPrefix "/" job.tokenFile;
          message = "services.ghorg.jobs.${name}.tokenFile must be null or an absolute path.";
        }
        {
          assertion = job.settings.cloneToPath == null || lib.hasPrefix "/" job.settings.cloneToPath;
          message = "services.ghorg.jobs.${name}.settings.cloneToPath must be null or an absolute path.";
        }
        {
          assertion = job.configFile == null || !(hasInlineConfig job);
          message = "services.ghorg.jobs.${name} cannot set configFile together with settings or rawSettings.";
        }
      ]) cfg.jobs
    );

    users.groups = lib.mkIf cfg.createGroup {
      ${cfg.group} = { };
    };

    users.users = lib.mkIf cfg.createUser {
      ${cfg.user} = {
        isSystemUser = true;
        group = cfg.group;
        home = cfg.dataDir;
        createHome = false;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.dataDir} ${cfg.dataDirMode} ${cfg.user} ${cfg.group} -"
    ];

    systemd.services.ghorg = {
      description = "Mirror repositories with ghorg";
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = [
        cfg.package
        pkgs.git
        pkgs.openssh
      ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.dataDir;
        Environment = [
          "HOME=${cfg.dataDir}"
          "GHORG_RECLONE_PATH=${recloneConfig}"
        ];
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = lib.escapeShellArgs [
          (lib.getExe cfg.package)
          "reclone"
        ];
      };
    };

    systemd.timers.ghorg = lib.mkIf (cfg.startAt != null) {
      description = "Run ghorg on a schedule";
      wantedBy = [ "timers.target" ];
      partOf = [ "ghorg.service" ];
      timerConfig = {
        OnCalendar = cfg.startAt;
        Unit = "ghorg.service";
      };
    };
  };

  meta = {
    doc = ./ghorg.md;
    maintainers = with lib.maintainers; [ CuSO4Deposit ];
  };
}
