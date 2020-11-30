{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "u2f";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  mkModuleOptions = global: {
    enable = mkOption {
      default = if global then false else modCfg.enable;
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
      default = if global then null else modCfg.authFile;
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
      default = if global then null else modCfg.appId;
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
      default = if global then "sufficient" else modCfg.control;
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
      default = if global then false else modCfg.debug;
      type = types.bool;
      description = ''
        Debug output to stderr.
      '';
    };

    interactive = mkOption {
      default = if global then false else modCfg.interactive;
      type = types.bool;
      description = ''
        Set to prompt a message and wait before testing the presence of a U2F device.
        Recommended if your device doesn’t have a tactile trigger.
      '';
    };

    cue = mkOption {
      default = if global then false else modCfg.cue;
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

  mkAuthConfig = svcCfg: {
    ${name} = {
      inherit (svcCfg.modules.${name}) control;
      path = "${pkgs.pam_u2f}/lib/security/pam_u2f.so";
      args = flatten [
        (optional svcCfg.modules.${name}.debug "debug")
        (optional (svcCfg.modules.${name}.authFile != null) "authFile=${svcCfg.modules.${name}.authFile}")
        (optional svcCfg.modules.${name}.interactive "interactive")
        (optional svcCfg.modules.${name}.cue "cue")
        (optional (svcCfg.modules.${name}.appId != null) "appid=${svcCfg.modules.${name}.appId}")
      ];
      order = 17000;
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

  config = mkIf (modCfg.enable || (utils.pam.anyEnable pamCfg name)) {
    environment.systemPackages = [ pkgs.pam_u2f ];
  };
}
