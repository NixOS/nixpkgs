{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.ecryptfs;

  anyEnable = any (attrByPath [ "modules" "ecryptfs" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Whether to enable the eCryptfs (one-time password) PAM module (mounting
        ecryptfs home directory on login).
      '';
    };
  };

  commonEntryConfig = {
    control = "optional";
    path = "${pkgs.ecryptfs}/lib/security/pam_ecryptfs.so";
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.ecryptfs = moduleOptions false;
            };

            config = mkIf config.modules.ecryptfs.enable {
              auth.ecryptfs = commonEntryConfig // {
                args = [ "unwrap" ];
                order = 22000;
              };

              password.ecryptfs = commonEntryConfig // {
                order = 2000;
              };

              session.ecryptfs = commonEntryConfig // {
                order = 5000;
              };
            };
          })
        );
      };

      modules.ecryptfs = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    boot.supportedFilesystems = [ "ecryptfs" ];
  };
}
