{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "p11";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Enables P11 PAM (<literal>pam_p11</literal>) module.

        If set, users can log in with SSH keys and PKCS#11 tokens.

        More information can be found <link
        xlink:href="https://github.com/OpenSC/pam_p11">here</link>.
      '';
    };

    control = mkOption {
      default = if global then "sufficient" else modCfg.control;
      type = utils.pam.controlType;
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

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit (svcCfg.modules.p11) control;
      path = "${pkgs.pam_p11}/lib/security/pam_p11.so";
      args = [ "${pkgs.opensc}/lib/opensc-pkcs11.so" ];
      order = 16000;
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

  config = mkIf (modCfg.enable || (utils.pam.anyEnable pamCfg name)) {
    environment.systemPackages = [ pkgs.pam_p11 ];
  };
}
