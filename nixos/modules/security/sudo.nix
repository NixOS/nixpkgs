{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.sudo;
  common = import ../../lib/sudo-common.nix {
    inherit config lib pkgs;
    defaultOptions = [ "SETENV" ];
    pname = "sudo";
  };
in
{
  options.security.sudo = attrsets.unionOfDisjoint common.options {
    enable = mkOption {
      type = types.bool;
      default = true;
      description =
        lib.mdDoc ''
          Whether to enable the {command}`sudo` command, which
          allows non-root users to execute commands as root.
        '';
    };
  };

  config = mkIf cfg.enable (mkMerge [
    common.config
    {
      assertions = [ {
        assertion = cfg.package.pname != "sudo-rs";
        message = ''
          NixOS' `sudo` module does not support `sudo-rs`; see `security.sudo-rs` instead.
        '';
      } ];

      security.wrappers = let
        owner = "root";
        group = if cfg.execWheelOnly then "wheel" else "root";
        setuid = true;
        permissions = if cfg.execWheelOnly then "u+rx,g+x" else "u+rx,g+x,o+x";
      in {
        sudoedit = {
          source = "${cfg.package.out}/bin/sudoedit";
          inherit owner group setuid permissions;
        };
      };
    }
  ]);
}
