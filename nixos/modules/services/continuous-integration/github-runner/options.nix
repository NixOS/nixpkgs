{ config, lib, pkgs, ... }:

with lib;

{
  enable = mkOption {
    default = false;
    example = true;
    description = lib.mdDoc ''
      Whether to enable GitHub Actions runner.

      Note: GitHub recommends using self-hosted runners with private repositories only. Learn more here:
      [About self-hosted runners](https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners).
    '';
    type = lib.types.bool;
  };

  url = mkOption {
    type = types.str;
    description = lib.mdDoc ''
      Repository to add the runner to.

      Changing this option triggers a new runner registration.

      IMPORTANT: If your token is org-wide (not per repository), you need to
      provide a github org link, not a single repository, so do it like this
      `https://github.com/nixos`, not like this
      `https://github.com/nixos/nixpkgs`.
      Otherwise, you are going to get a `404 NotFound`
      from `POST https://api.github.com/actions/runner-registration`
      in the configure script.
    '';
    example = "https://github.com/nixos/nixpkgs";
  };

  tokenFile = mkOption {
    type = types.path;
    description = lib.mdDoc ''
      The full path to a file which contains either a runner registration token or a
      personal access token (PAT).
      The file should contain exactly one line with the token without any newline.
      If a registration token is given, it can be used to re-register a runner of the same
      name but is time-limited. If the file contains a PAT, the service creates a new
      registration token on startup as needed. Make sure the PAT has a scope of
      `admin:org` for organization-wide registrations or a scope of
      `repo` for a single repository.

      Changing this option or the file's content triggers a new runner registration.
    '';
    example = "/run/secrets/github-runner/nixos.token";
  };

  name = mkOption {
    # Same pattern as for `networking.hostName`
    type = types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
    description = lib.mdDoc ''
      Name of the runner to configure. Defaults to the hostname.

      Changing this option triggers a new runner registration.
    '';
    example = "nixos";
    default = config.networking.hostName;
    defaultText = literalExpression "config.networking.hostName";
  };

  runnerGroup = mkOption {
    type = types.nullOr types.str;
    description = lib.mdDoc ''
      Name of the runner group to add this runner to (defaults to the default runner group).

      Changing this option triggers a new runner registration.
    '';
    default = null;
  };

  extraLabels = mkOption {
    type = types.listOf types.str;
    description = lib.mdDoc ''
      Extra labels in addition to the default (`["self-hosted", "Linux", "X64"]`).

      Changing this option triggers a new runner registration.
    '';
    example = literalExpression ''[ "nixos" ]'';
    default = [ ];
  };

  replace = mkOption {
    type = types.bool;
    description = lib.mdDoc ''
      Replace any existing runner with the same name.

      Without this flag, registering a new runner with the same name fails.
    '';
    default = false;
  };

  extraPackages = mkOption {
    type = types.listOf types.package;
    description = lib.mdDoc ''
      Extra packages to add to `PATH` of the service to make them available to workflows.
    '';
    default = [ ];
  };

  extraEnvironment = mkOption {
    type = types.attrs;
    description = ''
      Extra environment variables to set for the runner, as an attrset.
    '';
    example = {
      GIT_CONFIG = "/path/to/git/config";
    };
    default = {};
  };

  serviceOverrides = mkOption {
    type = types.attrs;
    description = ''
      Overrides for the systemd service. Can be used to adjust the sandboxing options.
    '';
    example = {
      ProtectHome = false;
    };
    default = {};
  };

  package = mkOption {
    type = types.package;
    description = lib.mdDoc ''
      Which github-runner derivation to use.
    '';
    default = pkgs.github-runner;
    defaultText = literalExpression "pkgs.github-runner";
  };

  ephemeral = mkOption {
    type = types.bool;
    description = lib.mdDoc ''
      If enabled, causes the following behavior:

      - Passes the `--ephemeral` flag to the runner configuration script
      - De-registers and stops the runner with GitHub after it has processed one job
      - On stop, systemd wipes the runtime directory (this always happens, even without using the ephemeral option)
      - Restarts the service after its successful exit
      - On start, wipes the state directory and configures a new runner

      You should only enable this option if `tokenFile` points to a file which contains a
      personal access token (PAT). If you're using the option with a registration token, restarting the
      service will fail as soon as the registration token expired.
    '';
    default = false;
  };

  user = mkOption {
    type = types.str;
    description = ''
      User under which to run the service. If null, will use a systemd dynamic user.
    '';
    default = null;
    defaultText = literalExpression "username";
  };
}
