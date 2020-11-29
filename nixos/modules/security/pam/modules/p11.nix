{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  pamLib = pamCfg.lib;
  cfg = pamCfg.modules.p11;

  anyEnable = any (attrByPath [ "modules" "p11" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Enables P11 PAM (<literal>pam_p11</literal>) module.

        If set, users can log in with SSH keys and PKCS#11 tokens.

        More information can be found <link
        xlink:href="https://github.com/OpenSC/pam_p11">here</link>.
      '';
    };

    control = mkOption {
      default = if global then "sufficient" else cfg.control;
      type = pamLib.controlType;
      description = ''
        This option sets pam "control".
        If you want to have multi factor authentication, use "required".
        If you want to use the PKCS#11 device instead of the regular
        password, use "sufficient".

        Read
        <citerefentry>
          <refentrytitle>pam.conf</refentrytitle>
          <manvolnum>5</manvolnum>
        </citerefentry>
        for better understanding of this option.
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
              modules.p11 = moduleOptions false;
            };

            config = mkIf config.modules.p11.enable {
              auth = {
                p11 = {
                  inherit (configmodules.p11) control;
                  path = "${pkgs.pam_p11}/lib/security/pam_p11.so";
                  args = [ "${pkgs.opensc}/lib/opensc-pkcs11.so" ];
                  order = 16000;
                };
              };
            };
          })
        );
      };

      modules.p11 = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    environment.systemPackages = [ pkgs.pam_p11 ];
  };
}
