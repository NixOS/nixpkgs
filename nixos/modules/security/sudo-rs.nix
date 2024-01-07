{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.sudo-rs;
  common = import ../../lib/sudo-common.nix {
    inherit config lib pkgs;
    pname = "sudo-rs";
  };
in
{
  options.security.sudo-rs = attrsets.unionOfDisjoint common.options {
    enable = mkEnableOption (mdDoc ''
      a memory-safe implementation of the {command}`sudo` command,
      which allows non-root users to execute commands as root.
    '');
  };

  config = mkIf cfg.enable (mkMerge [
    common.config
    {
      assertions = [ {
        assertion = ! config.security.sudo.enable;
        message = "`security.sudo` and `security.sudo-rs` cannot both be enabled";
      }];
      security.sudo.enable = mkDefault false;
      security.pam.services.sudo-i = { sshAgentAuth = true; usshAuth = true; };
    }
  ]);

  meta.maintainers = [ lib.maintainers.nicoo ];
}
