{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.tahoe;

  # The tahoe.cfg is ini-format.
  settingsFormat = pkgs.formats.ini { };

  # Get some helpers for generating the configuration.
  utils = import ./utils.nix { inherit config pkgs lib settingsFormat; };

  # These are the node options with special support.  They are a mix of
  # required options and options that were declared by this module in the past
  # and are kept for compatibility.
  nodeOptions = {
    nickname = mkOption {
      type = types.str;
      description = ''
        The nickname of this Tahoe node.
      '';
    };
    tub.port = mkOption {
      default = 3457;
      type = types.int;
      description = ''
        The port on which the tub will listen.

        This is the correct setting to tweak if you want Tahoe's storage
        system to listen on a different port.
      '';
    };
    tub.location = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = ''
        The external location that the node should listen on.

        This is the setting to tweak if there are multiple interfaces
        and you want to alter which interface Tahoe is advertising.

        If specified, the port should be included.
      '';
      };
    web.port = mkOption {
      default = 3456;
      type = types.int;
      description = ''
        The port on which the Web server will listen.

        This is the correct setting to tweak if you want Tahoe's WUI to
        listen on a different port.
      '';
    };
    client.introducer = mkOption {
      type = types.nullOr types.str;
      description = ''
        The furl for a Tahoe introducer node.

        Like all furls, keep this safe and don't share it.
      '';
    };
    client.helper = mkOption {
      type = types.nullOr types.str;
      description = ''
        The furl for a Tahoe helper node.

        Like all furls, keep this safe and don't share it.
      '';
    };
    client.shares.needed = mkOption {
      default = 3;
      type = types.int;
      description = ''
        The number of shares required to reconstitute a file.
      '';
    };
    client.shares.happy = mkOption {
      default = 7;
      type = types.int;
      description = ''
        The number of distinct storage nodes required to store
        a file.
      '';
    };
    client.shares.total = mkOption {
      default = 10;
      type = types.int;
      description = ''
        The number of shares required to store a file.
      '';
    };
    helper.enable = mkEnableOption "helper service";
    sftpd.enable = mkEnableOption "SFTP service";
    sftpd.port = mkOption {
      type = types.nullOr types.int;
      description = ''
        The description of a Twisted endpoint on which the SFTP server will listen.

        This is the correct setting to tweak if you want Tahoe's
        SFTP daemon to listen on a different port.
      '';
    };
    sftpd.hostPublicKeyFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        Path to the SSH host public key.
      '';
    };
    sftpd.hostPrivateKeyFile = mkOption {
      type = types.nullOr types.path;
      description = ''
        Path to the SSH host private key.
      '';
    };
    sftpd.accounts.file = mkOption {
      type = types.nullOr types.path;
      description = ''
        Path to the accounts file.
      '';
    };
    package = mkOption {
      default = pkgs.tahoe-lafs;
      defaultText = literalExpression "pkgs.tahoe-lafs";
      type = types.package;
      description = ''
        The package to use for the Tahoe LAFS daemon.
      '';
    };
  };

  # Like nodeOptions, but for introducers.
  introducerOptions = {
    nickname = mkOption {
      type = types.str;
      description = ''
        The nickname of this Tahoe introducer.
      '';
    };
    tub.port = mkOption {
      default = 3458;
      type = types.int;
      description = ''
        The port on which the introducer will listen.
      '';
    };
    tub.location = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = ''
        The external location that the introducer should listen on.

        If specified, the port should be included.
      '';
    };
    package = mkOption {
      default = pkgs.tahoe-lafs;
      defaultText = literalExpression "pkgs.tahoe-lafs";
      type = types.package;
      description = ''
        The package to use for the Tahoe LAFS daemon.
      '';
    };
  };
in
{
  options.services.tahoe = {
    introducers = mkOption {
      type = with types; attrsOf (submodule {
        options = introducerOptions;
      });
      default = {};
      description = ''
        The Tahoe introducers.
      '';
    };

    nodes = mkOption {
      type = with types; attrsOf (submodule {
        options = nodeOptions // {
          settings = mkOption {
            description = "Configuration to be written to the node's tahoe.cfg.";
            example = {
              node = {
                "nickname" = "mynode";
                "tub.port" = 3457;
                "tub.location" = "tcp:3457";
                "web.port" = 3456;
              };
              client = {
                "shares.needed" = 3;
                "shares.happy" = 7;
                "shares.total" = 10;
              };
              storage = {
                enable = true;
                reserved_space = "1G";
              };
            };
            type = submodule {
              freeformType = settingsFormat.type;
            };
          };
        };
      });

      default = {};

      description = ''
        The Tahoe nodes.
      '';
    };
  };

  config = let
    introducerConfigurations = with utils; mkIf (cfg.introducers != {}) {
      systemd.services = mkServices "introducer" cfg.introducers;
      users.users = mkUsers "introducer" cfg.introducers;
      users.groups = mkGroups "introducer" cfg.introducers;
    };
    nodeConfigurations = with utils; lib.mkIf (cfg.nodes != {}) {
      systemd.services = mkServices "node" cfg.nodes;
      users.users = mkUsers "node" cfg.nodes;
      users.groups = mkGroups "node" cfg.nodes;
    };
  in
    lib.mkMerge [
      introducerConfigurations
      nodeConfigurations
    ];
}
