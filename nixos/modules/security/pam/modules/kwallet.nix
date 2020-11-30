{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "kwallet";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        If enabled, pam_wallet will attempt to automatically unlock the user's
        default KDE wallet upon login. If the user has no wallet named
        "kdewallet", or the login password does not match their wallet
        password, KDE will prompt separately after login.
      '';
    };
  };

  control = "optional";
  path = "${pkgs.plasma5.kwallet-pam}/lib/security/pam_kwallet5.so";

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = [
        "kwalletd=${pkgs.kdeFrameworks.kwallet.bin}/bin/kwalletd5"
      ];
      order = 24000;
    };
  };

  mkSessionConfig = svcCfg: {
    ${name} = {
      inherit control path;
      args = [
        "kwalletd=${pkgs.kdeFrameworks.kwallet.bin}/bin/kwalletd5"
      ];
      order = 16000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };
}
