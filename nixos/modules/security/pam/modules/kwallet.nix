{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.kwallet;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        If enabled, pam_wallet will attempt to automatically unlock the user's
        default KDE wallet upon login. If the user has no wallet named
        "kdewallet", or the login password does not match their wallet
        password, KDE will prompt separately after login.
      '';
    };
  };
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.kwallet = moduleOptions false;
            };

            config = mkIf config.modules.kwallet.enable {
              auth = mkDefault {
                kwallet = {
                  control = "optional";
                  path = "${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so";
                  args = [
                    "kwalletd=${pkgs.kdeFrameworks.kwallet.bin}/bin/kwalletd5"
                  ];
                  order = 24000;
                };
              };

              session = mkDefault {
                kwallet = {
                  control = "optional";
                  path = "${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so";
                  args = [
                    "kwalletd=${pkgs.kdeFrameworks.kwallet.bin}/bin/kwalletd5"
                  ];
                  order = 16000;
                };
              };
            };
          })
        );
      };

      modules.kwallet = moduleOptions true;
    };
  };
}
