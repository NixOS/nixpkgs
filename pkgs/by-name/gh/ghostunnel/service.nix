# Non-module dependencies (`importApply`)
{
  # `modules/generic/pkgs/by-name/gh/ghostunnel/commands/ghostunnel/server.nix`.
  command,
}:

# Service module
{
  lib,
  config,
  options,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    mapAttrsToList
    mkOption
    types
    ;
  cfg = config.ghostunnel;

in
{
  # https://nixos.org/manual/nixos/unstable/#modular-services
  _class = "service";
  options = {
    ghostunnel = mkOption {
      description = "Configuration of ghostunnel.";
      default = { };
      type = types.submodule [
        command
        {
          options = {
            package = mkOption {
              defaultText = "The ghostunnel package that provided this module.";
            };

            extraArguments = mkOption {
              description = "Extra arguments to pass to `ghostunnel server`";
              type = types.listOf types.str;
              default = [ ];
            };
          };
        }
      ];
    };
  };

  config = {
    inherit (cfg) assertions warnings;

    process.argv = cfg.portable.argv ++ cfg.extraArguments;
  }
  # Refine the service for systemd
  // lib.optionalAttrs (options ? systemd) (
    let
      # Build credential flags with systemd variable substitution
      credentialFlags = concatStringsSep " " (
        mapAttrsToList (name: _: "--${name}=\${CREDENTIALS_DIRECTORY}/${name}") cfg.credentials
      );
    in
    {
      # Use mainExecStart to add credential flags with systemd variable substitution
      systemd.mainExecStart =
        config.systemd.lib.escapeSystemdExecArgs config.process.argv
        + lib.optionalString (credentialFlags != "") " ${credentialFlags}";

      systemd.service = {
        after = [ "network.target" ];
        wants = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Restart = "always";
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          DynamicUser = true;
          LoadCredential = mapAttrsToList (name: path: "${name}:${path}") cfg.credentials;
        };
      };
    }
  );
}
