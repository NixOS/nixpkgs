{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "sshAgent";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Enable sudo logins if the user's SSH agent provides a key
        present in <filename>~/.ssh/authorized_keys</filename>.
        This allows machines to exclusively use SSH keys instead of
        passwords.
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = {
      control = "sufficient";
      path = "${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so";
      args = [
        "file=${concatStringsSep ":" config.services.openssh.authorizedKeysFiles}"
      ];
      order = 14000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkAuthConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name}.enable;
    };
  };
}
