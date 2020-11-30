{ config, pkgs, lib, utils, ... }:

with lib;

let
  pamCfg = config.security.pam;
  cfg = pamCfg.modules.u2f;

  anyEnable = any (attrByPath [ "modules" "u2f" "enable" ] false) (attrValues pamCfg.services);

  moduleOptions = global: {
    enable = mkOption {
      default = if global then false else cfg.enable;
      type = types.bool;
      description = ''
        Enables U2F PAM (<literal>pam-u2f</literal>) module.
        If set, users listed in
        <filename>$XDG_CONFIG_HOME/Yubico/u2f_keys</filename> (or
        <filename>$HOME/.config/Yubico/u2f_keys</filename> if XDG variable is
        not set) are able to log in with the associated U2F key. The path can
        be changed using <option>security.pam.u2f.authFile</option> option.
        File format is:
        <literal>username:first_keyHandle,first_public_key: second_keyHandle,second_public_key</literal>
        This file can be generated using <command>pamu2fcfg</command> command.
        More information can be found <link
        xlink:href="https://developers.yubico.com/pam-u2f/">here</link>.
      '';
    };

    authFile = mkOption {
      default = if global then null else cfg.authFile;
      type = with types; nullOr path;
      description = ''
        By default <literal>pam-u2f</literal> module reads the keys from
        <filename>$XDG_CONFIG_HOME/Yubico/u2f_keys</filename> (or
        <filename>$HOME/.config/Yubico/u2f_keys</filename> if XDG variable is
        not set).
        If you want to change auth file locations or centralize database (for
        example use <filename>/etc/u2f-mappings</filename>) you can set this
        option.
        File format is:
        <literal>username:first_keyHandle,first_public_key: second_keyHandle,second_public_key</literal>
        This file can be generated using <command>pamu2fcfg</command> command.
        More information can be found <link
        xlink:href="https://developers.yubico.com/pam-u2f/">here</link>.
      '';
    };

    appId = mkOption {
      default = if global then null else cfg.appId;
      type = with types; nullOr str;
      description = ''
        By default <literal>pam-u2f</literal> module sets the application
        ID to <literal>pam://$HOSTNAME</literal>.
        When using <command>pamu2fcfg</command>, you can specify your
        application ID with the <literal>-i</literal> flag.
        More information can be found <link
        xlink:href="https://developers.yubico.com/pam-u2f/Manuals/pam_u2f.8.html">
        here</link>
      '';
    };

    control = mkOption {
      default = if global then "sufficient" else cfg.control;
      type = utils.pam.controlType;
      description = ''
        This option sets pam "control".
        If you want to have multi factor authentication, use "required".
        If you want to use U2F device instead of regular password, use "sufficient".
        Read
        <citerefentry>
        <refentrytitle>pam.conf</refentrytitle>
        <manvolnum>5</manvolnum>
        </citerefentry>
        for better understanding of this option.
      '';
    };

    debug = mkOption {
      default = if global then false else cfg.debug;
      type = types.bool;
      description = ''
        Debug output to stderr.
      '';
    };

    interactive = mkOption {
      default = if global then false else cfg.interactive;
      type = types.bool;
      description = ''
        Set to prompt a message and wait before testing the presence of a U2F device.
        Recommended if your device doesn’t have a tactile trigger.
      '';
    };

    cue = mkOption {
      default = if global then false else cfg.cue;
      type = types.bool;
      description = ''
        By default <literal>pam-u2f</literal> module does not inform user
        that he needs to use the u2f device, it just waits without a prompt.
        If you set this option to <literal>true</literal>,
        <literal>cue</literal> option is added to <literal>pam-u2f</literal>
        module and reminder message will be displayed.
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
              modules.u2f = moduleOptions false;
            };

            config = mkIf config.modules.u2f.enable {
              auth = mkDefault {
                u2f = {
                  inherit (config.modules.u2f) control;
                  path = "${pkgs.pam_u2f}/lib/security/pam_u2f.so";
                  args = flatten [
                    (optional config.modules.u2f.debug "debug")
                    (optional (config.modules.u2f.authFile != null) "authFile=${config.modules.u2f.authFile}")
                    (optional config.modules.u2f.interactive "interactive")
                    (optional config.modules.u2f.cue "cue")
                    (optional (config.modules.u2f.appId != null) "appid=${config.modules.u2f.appId}")
                  ];
                  order = 17000;
                };
              };
            };
          })
        );
      };

      modules.u2f = moduleOptions true;
    };
  };

  config = mkIf (cfg.enable || anyEnable) {
    environment.systemPackages = [ pkgs.pam_u2f ];
  };
}
