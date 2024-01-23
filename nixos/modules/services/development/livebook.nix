{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.livebook;
in
{
  options.services.livebook = {
    # Since livebook doesn't have a granular permission system (a user
    # either has access to all the data or none at all), the decision
    # was made to run this as a user service.  If that changes in the
    # future, this can be changed to a system service.
    enableUserService = mkEnableOption "a user service for Livebook";

    package = mkPackageOption pkgs "livebook" { };

    environmentFile = mkOption {
      type = types.path;
      description = lib.mdDoc ''
        Environment file as defined in {manpage}`systemd.exec(5)` passed to the service.

        This must contain at least `LIVEBOOK_PASSWORD` or
        `LIVEBOOK_TOKEN_ENABLED=false`.  See `livebook server --help`
        for other options.'';
    };

    erlang_node_short_name = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "livebook";
      description = "A short name for the distributed node.";
    };

    erlang_node_name = mkOption {
      type = with types; nullOr str;
      default = null;
      example = "livebook@127.0.0.1";
      description = "The name for the app distributed node.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "The port to start the web application on.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = lib.mdDoc ''
        The address to start the web application on.  Must be a valid IPv4 or
        IPv6 address.
      '';
    };

    options = mkOption {
      type = with types; attrsOf str;
      default = { };
      description = lib.mdDoc ''
        Additional options to pass as command-line arguments to the server.
      '';
      example = literalExpression ''
        {
          cookie = "a value shared by all nodes in this cluster";
        }
      '';
    };

    extraPackages = mkOption {
      type = with types; listOf package;
      default = [ ];
      description = lib.mdDoc ''
        Extra packages to make available to the Livebook service.
      '';
      example = literalExpression "with pkgs; [ gcc gnumake ]";
    };
  };

  config = mkIf cfg.enableUserService {
    systemd.user.services.livebook = {
      serviceConfig = {
        Restart = "always";
        EnvironmentFile = cfg.environmentFile;
        ExecStart =
          let
            args = lib.cli.toGNUCommandLineShell { } ({
              inherit (cfg) port;
              ip = cfg.address;
              name = cfg.erlang_node_name;
              sname = cfg.erlang_node_short_name;
            } // cfg.options);
          in
            "${cfg.package}/bin/livebook server ${args}";
      };
      path = [ pkgs.bash ] ++ cfg.extraPackages;
      wantedBy = [ "default.target" ];
    };
  };

  meta.doc = ./livebook.md;
}
