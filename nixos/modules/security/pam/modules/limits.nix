{ config, pkgs, lib, utils, ... }:

with lib;

let
  name = "limits";
  pamCfg = config.security.pam;
  modCfg = pamCfg.modules.${name};

  limitSubmodule = {
    options = {
      domain = mkOption {
        type = types.str;
        description = ''
          domain field of the limit.
          See
          <citerefentry>
          <refentrytitle>limits.conf</refentrytitle>
          <manvolnum>5</manvolnum>
          </citerefentry>
          for more information.
        '';
      };
      type = mkOption {
        type = types.str;
        description = ''
          type field of the limit.
          See
          <citerefentry>
          <refentrytitle>limits.conf</refentrytitle>
          <manvolnum>5</manvolnum>
          </citerefentry>
          for more information.
        '';
      };
      item = mkOption {
        type = types.str;
        description = ''
          item field of the limit.
          See
          <citerefentry>
          <refentrytitle>limits.conf</refentrytitle>
          <manvolnum>5</manvolnum>
          </citerefentry>
          for more information.
        '';
      };
      value = mkOption {
        type = with types; oneOf [ str int ];
        description = ''
          value field of the limit.
          See
          <citerefentry>
          <refentrytitle>limits.conf</refentrytitle>
          <manvolnum>5</manvolnum>
          </citerefentry>
          for more information.
        '';
      };
    };
  };

  mkModuleOptions = global: mkOption {
    type = with types; attrsOf (submodule limitSubmodule);
    default = if global then {} else modCfg;
    description = ''
      Define resource limits that should apply to users or groups.
      Each item in the list should be an attribute set with a
      <varname>domain</varname>, <varname>type</varname>,
      <varname>item</varname>, and <varname>value</varname>
      attribute. The syntax and semantics of these attributes
      must be that described in the limits.conf(5) man page.

      Note that these limits do not apply to systemd services,
      whose limits can be changed via <option>systemd.extraConfig</option>
      instead.
    '';
  };

  makeLimitsConf = limits: pkgs.writeText "limits.conf"
    (concatMapStringsSep "\n" ({ domain, type, item, value }:
      "${domain} ${type} ${item} ${toString value}")
    (attrValues limits));

  mkSessionConfig = svcCfg: {
    ${name} = {
      control = "required";
      path = "${pkgs.pam}/lib/security/pam_limits.so";
      args = [ "conf=${makeLimitsConf svcCfg.modules.${name}}" ];
      order = 13000;
    };
  };
in
{
  options = {
    security.pam = utils.pam.mkPamModule {
      inherit name mkModuleOptions mkSessionConfig;
      mkSvcConfigCondition = svcCfg: svcCfg.modules.${name} != {};
    };
  };
}
