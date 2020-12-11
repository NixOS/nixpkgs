{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "yubico";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
      type = types.bool;
      description = ''
        Enables Yubico PAM (<literal>yubico-pam</literal>) module.
        If set, users listed in
        <filename>~/.yubico/authorized_yubikeys</filename>
        are able to log in with the associated Yubikey tokens.
        The file must have only one line:
        <literal>username:yubikey_token_id1:yubikey_token_id2</literal>
        More information can be found <link
        xlink:href="https://developers.yubico.com/yubico-pam/">here</link>.
      '';
    };
    control = mkOption {
      default = if global then "sufficient" else modCfg.control;
      type = utils.pam.controlType;
      description = ''
        This option sets pam "control".
        If you want to have multi factor authentication, use "required".
        If you want to use Yubikey instead of regular password, use "sufficient".
        Read
        <citerefentry>
        <refentrytitle>pam.conf</refentrytitle>
        <manvolnum>5</manvolnum>
        </citerefentry>
        for better understanding of this option.
      '';
    };
    id = mkOption {
      default = null;
      example = 42;
      type = with types; nullOr int;
      description = "client id";
    };
    debug = mkOption {
      default = if global then false else modCfg.debug;
      type = types.bool;
      description = ''
        Debug output to stderr.
      '';
    };
    mode = mkOption {
      default = if global then "client" else modCfg.mode;
      type = types.enum [ "client" "challenge-response" ];
      description = ''
        Mode of operation.
        Use "client" for online validation with a YubiKey validation service such as
        the YubiCloud.
        Use "challenge-response" for offline validation using YubiKeys with HMAC-SHA-1
        Challenge-Response configurations. See the man-page ykpamcfg(1) for further
        details on how to configure offline Challenge-Response validation.
        More information can be found <link
        xlink:href="https://developers.yubico.com/yubico-pam/Authentication_Using_Challenge-Response.html">here</link>.
      '';
    };
  };

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit (svcCfg.modules.${name}) control;
      path = "${pkgs.yubico-pam}/lib/security/pam_yubico.so";
      args = flatten [
        "mode=${toString svcCfg.modules.${name}.mode}"
        (optional (svcCfg.modules.${name}.mode == "client") "id=${toString svcCfg.modules.${name}.id}")
        (optional svcCfg.modules.${name}.debug "debug")
      ];
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
