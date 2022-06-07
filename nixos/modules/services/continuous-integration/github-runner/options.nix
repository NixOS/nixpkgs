{ config, lib, pkgs, ... }:

with lib;

{
  enable = mkOption {
    default = false;
    example = true;
    description = ''
      Whether to enable GitHub Actions runner.

      Note: GitHub recommends using self-hosted runners with private repositories only. Learn more here:
      <link xlink:href="https://docs.github.com/en/actions/hosting-your-own-runners/about-self-hosted-runners"
      >About self-hosted runners</link>.
    '';
    type = lib.types.bool;
  };

  url = mkOption {
    type = types.str;
    description = ''
      Repository to add the runner to.

      Changing this option triggers a new runner registration.

      IMPORTANT: If your token is org-wide (not per repository), you need to
      provide a github org link, not a single repository, so do it like this
      <literal>https://github.com/nixos</literal>, not like this
      <literal>https://github.com/nixos/nixpkgs</literal>.
      Otherwise, you are going to get a <literal>404 NotFound</literal>
      from <literal>POST https://api.github.com/actions/runner-registration</literal>
      in the configure script.
    '';
    example = "https://github.com/nixos/nixpkgs";
  };

  tokenFile = mkOption {
    type = types.path;
    description = ''
      The full path to a file which contains the runner registration token.
      The file should contain exactly one line with the token without any newline.
      The token can be used to re-register a runner of the same name but is time-limited.

      Changing this option or the file's content triggers a new runner registration.
    '';
    example = "/run/secrets/github-runner/nixos.token";
  };

  name = mkOption {
    # Same pattern as for `networking.hostName`
    type = types.strMatching "^$|^[[:alnum:]]([[:alnum:]_-]{0,61}[[:alnum:]])?$";
    description = ''
      Name of the runner to configure. Defaults to the hostname.

      Changing this option triggers a new runner registration.
    '';
    example = "nixos";
    default = config.networking.hostName;
    defaultText = literalExpression "config.networking.hostName";
  };

  runnerGroup = mkOption {
    type = types.nullOr types.str;
    description = ''
      Name of the runner group to add this runner to (defaults to the default runner group).

      Changing this option triggers a new runner registration.
    '';
    default = null;
  };

  extraLabels = mkOption {
    type = types.listOf types.str;
    description = ''
      Extra labels in addition to the default (<literal>["self-hosted", "Linux", "X64"]</literal>).

      Changing this option triggers a new runner registration.
    '';
    example = literalExpression ''[ "nixos" ]'';
    default = [ ];
  };

  replace = mkOption {
    type = types.bool;
    description = ''
      Replace any existing runner with the same name.

      Without this flag, registering a new runner with the same name fails.
    '';
    default = false;
  };

  extraPackages = mkOption {
    type = types.listOf types.package;
    description = ''
      Extra packages to add to <literal>PATH</literal> of the service to make them available to workflows.
    '';
    default = [ ];
  };

  package = mkOption {
    type = types.package;
    description = ''
      Which github-runner derivation to use.
    '';
    default = pkgs.github-runner;
    defaultText = literalExpression "pkgs.github-runner";
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
