{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.trezord;
in {

  ### docs

  meta = {
    # Don't edit the docbook xml directly, edit the md and generate it:
    # `pandoc trezord.md -t docbook --top-level-division=chapter --extract-media=media -f markdown-smart --lua-filter ../../../../doc/build-aux/pandoc-filters/myst-reader/roles.lua --lua-filter ../../../../doc/build-aux/pandoc-filters/docbook-writer/rst-roles.lua > trezord.xml`
    doc = ./trezord.xml;
  };

  ### interface

  options = {
    services.trezord = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable Trezor bridge daemon, for use with Trezor hardware bitcoin wallets.
        '';
      };

      emulator.enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Enable Trezor emulator support.
          '';
       };

      emulator.port = mkOption {
        type = types.port;
        default = 21324;
        description = lib.mdDoc ''
          Listening port for the Trezor emulator.
          '';
      };
    };
  };

  ### implementation

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.trezor-udev-rules ];

    systemd.services.trezord = {
      description = "Trezor Bridge";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.trezord}/bin/trezord-go ${optionalString cfg.emulator.enable "-e ${builtins.toString cfg.emulator.port}"}";
        User = "trezord";
      };
    };

    users.users.trezord = {
      group = "trezord";
      description = "Trezor bridge daemon user";
      isSystemUser = true;
    };

    users.groups.trezord = {};
  };
}

