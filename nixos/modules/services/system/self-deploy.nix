{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.self-deploy;

  workingDirectory = "/var/lib/nixos-self-deploy";
  repositoryDirectory = "${workingDirectory}/repo";
  outPath = "${workingDirectory}/system";

  gitWithRepo = "git -C ${repositoryDirectory}";

  renderNixArgs =
    args:
    let
      toArg =
        key: value:
        if builtins.isString value then
          " --argstr ${lib.escapeShellArg key} ${lib.escapeShellArg value}"
        else
          " --arg ${lib.escapeShellArg key} ${lib.escapeShellArg (toString value)}";
    in
    lib.concatStrings (lib.mapAttrsToList toArg args);

  isPathType = x: lib.types.path.check x;

in
{
  options.services.self-deploy = {
    enable = lib.mkEnableOption "self-deploy";

    nixFile = lib.mkOption {
      type = lib.types.path;

      default = "/default.nix";

      description = ''
        Path to nix file in repository. Leading '/' refers to root of
        git repository.
      '';
    };

    nixAttribute = lib.mkOption {
      type = with lib.types; nullOr str;

      default = null;

      description = ''
        Attribute of `nixFile` that builds the current system.
      '';
    };

    nixArgs = lib.mkOption {
      type = lib.types.attrs;

      default = { };

      description = ''
        Arguments to `nix-build` passed as `--argstr` or `--arg` depending on
        the type.
      '';
    };

    switchCommand = lib.mkOption {
      type = lib.types.enum [
        "boot"
        "switch"
        "dry-activate"
        "test"
      ];

      default = "switch";

      description = ''
        The `switch-to-configuration` subcommand used.
      '';
    };

    repository = lib.mkOption {
      type =
        with lib.types;
        oneOf [
          path
          str
        ];

      description = ''
        The repository to fetch from. Must be properly formatted for git.

        If this value is set to a path (must begin with `/`) then it's
        assumed that the repository is local and the resulting service
        won't wait for the network to be up.

        If the repository will be fetched over SSH, you must add an
        entry to `programs.ssh.knownHosts` for the SSH host for the fetch
        to be successful.
      '';
    };

    sshKeyFile = lib.mkOption {
      type = with lib.types; nullOr path;

      default = null;

      description = ''
        Path to SSH private key used to fetch private repositories over
        SSH.
      '';
    };

    branch = lib.mkOption {
      type = lib.types.str;

      default = "master";

      description = ''
        Branch to track

        Technically speaking any ref can be specified here, as this is
        passed directly to a `git fetch`, but for the use-case of
        continuous deployment you're likely to want to specify a branch.
      '';
    };

    startAt = lib.mkOption {
      type = with lib.types; either str (listOf str);

      default = "hourly";

      description = ''
        The schedule on which to run the `self-deploy` service. Format
        specified by `systemd.time 7`.

        This value can also be a list of `systemd.time 7` formatted
        strings, in which case the service will be started on multiple
        schedules.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.self-deploy = rec {
      inherit (cfg) startAt;

      serviceConfig.Type = "oneshot";

      requires = lib.mkIf (!(isPathType cfg.repository)) [ "network-online.target" ];

      after = requires;

      environment.GIT_SSH_COMMAND = lib.mkIf (
        cfg.sshKeyFile != null
      ) "${pkgs.openssh}/bin/ssh -i ${lib.escapeShellArg cfg.sshKeyFile}";

      restartIfChanged = false;

      path =
        with pkgs;
        [
          git
          gnutar
          gzip
          nix
        ]
        ++ lib.optionals (cfg.switchCommand == "boot") [ systemd ];

      script = ''
        if [ ! -e ${repositoryDirectory} ]; then
          mkdir --parents ${repositoryDirectory}
          git init ${repositoryDirectory}
        fi

        ${gitWithRepo} fetch ${lib.escapeShellArg cfg.repository} ${lib.escapeShellArg cfg.branch}

        ${gitWithRepo} checkout FETCH_HEAD

        nix-build${renderNixArgs cfg.nixArgs} ${
          lib.cli.toCommandLineShell
            (optionName: {
              option = "--${optionName}";
              sep = null;
              explicitBool = false;
            })
            {
              attr = cfg.nixAttribute;
              out-link = outPath;
            }
        } ${lib.escapeShellArg "${repositoryDirectory}${cfg.nixFile}"}

        ${lib.optionalString (
          cfg.switchCommand != "test"
        ) "nix-env --profile /nix/var/nix/profiles/system --set ${outPath}"}

        ${outPath}/bin/switch-to-configuration ${cfg.switchCommand}

        rm ${outPath}

        ${gitWithRepo} gc --prune=all

        ${lib.optionalString (cfg.switchCommand == "boot") "systemctl reboot"}
      '';
    };
  };
}
