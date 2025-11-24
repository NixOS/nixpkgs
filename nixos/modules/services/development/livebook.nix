{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.livebook;
in
{
  options.services.livebook = {
    # Since livebook doesn't have a granular permission system (a user
    # either has access to all the data or none at all), the decision
    # was made to run this as a user service.  If that changes in the
    # future, this can be changed to a system service.
    enableUserService = lib.mkEnableOption "a user service for Livebook";

    package = lib.mkPackageOption pkgs "livebook" { };

    environment = lib.mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            bool
            int
            str
          ])
        );
      default = { };
      description = ''
        Environment variables to set.

        Livebook is configured through the use of environment variables. The
        available configuration options can be found in the [Livebook
        documentation](https://hexdocs.pm/livebook/readme.html#environment-variables).

        Note that all environment variables set through this configuration
        parameter will be readable by anyone with access to the host
        machine. Therefore, sensitive information like {env}`LIVEBOOK_PASSWORD`
        or {env}`LIVEBOOK_COOKIE` should never be set using this configuration
        option, but should instead use
        [](#opt-services.livebook.environmentFile). See the documentation for
        that option for more information.

        Any environment variables specified in the
        [](#opt-services.livebook.environmentFile) will supersede environment
        variables specified in this option.
      '';

      example = lib.literalExpression ''
        {
          LIVEBOOK_PORT = 8080;
        }
      '';
    };

    environmentFile = lib.mkOption {
      type = with lib.types; nullOr lib.types.path;
      default = null;
      description = ''
        Additional environment file as defined in {manpage}`systemd.exec(5)`.

        Secrets like {env}`LIVEBOOK_PASSWORD` (which is used to specify the
        password needed to access the livebook site) or {env}`LIVEBOOK_COOKIE`
        (which is used to specify the
        [cookie](https://www.erlang.org/doc/reference_manual/distributed.html#security)
        used to connect to the running Elixir system) may be passed to the
        service without making them readable to everyone with access to
        systemctl by using this configuration parameter.

        Note that this file needs to be available on the host on which
        `livebook` is running.

        For security purposes, this file should contain at least
        {env}`LIVEBOOK_PASSWORD` or {env}`LIVEBOOK_TOKEN_ENABLED=false`.

        See the [Livebook
        documentation](https://hexdocs.pm/livebook/readme.html#environment-variables)
        and the [](#opt-services.livebook.environment) configuration parameter
        for further options.
      '';
      example = "/var/lib/livebook.env";
    };

    extraPackages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        Extra packages to make available to the Livebook service.
      '';
      example = lib.literalExpression "with pkgs; [ gcc gnumake ]";
    };
  };

  config = lib.mkIf cfg.enableUserService {
    systemd.user.services.livebook = {
      serviceConfig = {
        Restart = "always";
        EnvironmentFile = cfg.environmentFile;
        ExecStart = "${cfg.package}/bin/livebook start";
        KillMode = "mixed";

        # Fix for the issue described here:
        # https://github.com/livebook-dev/livebook/issues/2691
        #
        # Without this, the livebook service fails to start and gets
        # stuck running a `cat /dev/urandom | tr | fold` pipeline.
        IgnoreSIGPIPE = false;
      };
      environment = lib.mapAttrs (
        name: value: if lib.isBool value then lib.boolToString value else toString value
      ) cfg.environment;
      path = [ pkgs.bash ] ++ cfg.extraPackages;
      wantedBy = [ "default.target" ];
    };
  };

  meta = {
    doc = ./livebook.md;
    maintainers = with lib.maintainers; [
      munksgaard
      scvalex
    ];
  };
}
