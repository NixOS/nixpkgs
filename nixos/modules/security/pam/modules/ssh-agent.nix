{ config, pkgs, lib, ... }:

with lib;

let
  topCfg = config;
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.sshAgent;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Enable sudo logins if the user's SSH agent provides a key
        present in <filename>~/.ssh/authorized_keys</filename>.
        This allows machines to exclusively use SSH keys instead of
        passwords.
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
              modules.sshAgent = moduleOptions false;
            };

            config = mkIf config.modules.sshAgent.enable {
              auth = {
                sshAgent = {
                  control = "sufficient";
                  path = "${pkgs.pam_ssh_agent_auth}/libexec/pam_ssh_agent_auth.so";
                  args = [
                    "file=${lib.concatStringsSep ":" topCfg.services.openssh.authorizedKeysFiles}"
                  ];
                  order = 14000;
                };
              };
            };
          })
        );
      };

      modules.sshAgent = moduleOptions true;
    };
  };
}
