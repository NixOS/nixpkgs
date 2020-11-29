{ config, pkgs, lib, ... }:

with lib;

let
  pamCfg = config.security.pam;
  pamLib = pamCfg.lib;
  cfg = pamCfg.modules.yubico;

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
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
      default = if global then "sufficient" else cfg.control;
      type = pamLib.controlType;
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
      example = if global then 42 else cfg.id;
      type = with types; nullOr int;
      description = "client id";
    };
    debug = mkOption {
      default = if global then false else cfg.debug;
      type = types.bool;
      description = ''
        Debug output to stderr.
      '';
    };
    mode = mkOption {
      default = if global then "client" else cfg.mode;
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
in
{
  options = {
    security.pam = {
      services = mkOption {
        type = with types; attrsOf (submodule
          ({ config, ... }: {
            options = {
              modules.yubico = moduleOptions false;
            };

            config = mkIf config.modules.yubico.enable {
              auth.yubico = {
                inherit (config.modules.yubico) control;
                path = "${pkgs.yubico-pam}/lib/security/pam_yubico.so";
                args = flatten [
                  "mode=${toString config.modules.yubico.mode}"
                  (optional (config.modules.yubico.mode == "client") "id=${toString config.modules.yubico.id}")
                  (optional config.modules.yubico.debug "debug")
                ];
              };
            };
          })
        );
      };

      modules.yubico = moduleOptions true;
    };
  };
}
