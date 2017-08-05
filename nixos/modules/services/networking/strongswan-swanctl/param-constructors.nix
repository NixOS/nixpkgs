# In the following context a parameter is an attribute set that
# contains a NixOS option and a render function. It also contains the
# attribute: '_type = "param"' so we can distinguish it from other
# sets.
#
# The render function is used to convert the value of the option to a
# snippet of strongswan.conf. Most parameters simply render their
# value to a string. For example, take the following parameter:
#
#   threads = mkIntParam 10 "Threads to use for request handling.";
#
# When a users defines the corresponding option as for example:
#
#   services.strongswan-swanctl.strongswan.threads = 32;
#
# It will get rendered to the following snippet in strongswan.conf:
#
#   threads = 32
#
# Some parameters however need to be able to change the attribute
# name. For example, take the following parameter:
#
#   id = mkPrefixedAttrsOfParam (mkOptionalStrParam "") "...";
#
# A user can define the corresponding option as for example:
#
#   id = {
#     "foo" = "bar";
#     "baz" = "qux";
#   };
#
# This will get rendered to the following snippet:
#
#   foo-id = bar
#   baz-id = qux
#
# For this reason the render function is not simply a function from
# value -> string but a function from a value to an attribute set:
# { "${name}" = string }. This allows parameters to change the attribute
# name like in the previous example.

lib :

with lib;
with (import ./param-lib.nix lib);

rec {
  mkParamOfType = type : strongswanDefault : description : {
    _type = "param";
    option = mkOption {
      type = types.nullOr type;
      default = null;
      description = documentDefault description strongswanDefault;
    };
    render = single toString;
  };

  documentDefault = description : strongswanDefault :
    if isNull strongswanDefault
    then description
    else description + ''
      </para><para>
      StrongSwan default: <literal><![CDATA[${builtins.toJSON strongswanDefault}]]></literal>
    '';

  single = f: name: value: { "${name}" = f value; };

  mkStrParam         = mkParamOfType types.str;
  mkOptionalStrParam = mkStrParam null;

  mkEnumParam = values : mkParamOfType (types.enum values);

  mkIntParam         = mkParamOfType types.int;
  mkOptionalIntParam = mkIntParam null;

  # We should have floats in Nix...
  mkFloatParam = mkStrParam;

  # TODO: Check for hex format:
  mkHexParam         = mkStrParam;
  mkOptionalHexParam = mkOptionalStrParam;

  # TODO: Check for duration format:
  mkDurationParam         = mkStrParam;
  mkOptionalDurationParam = mkOptionalStrParam;

  mkYesNoParam = strongswanDefault : description : {
    _type = "param";
    option = mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = documentDefault description strongswanDefault;
    };
    render = single (b: if b then "yes" else "no");
  };
  yes = true;
  no  = false;

  mkSpaceSepListParam = mkSepListParam " ";
  mkCommaSepListParam = mkSepListParam ",";

  mkSepListParam = sep : strongswanDefault : description : {
    _type = "param";
    option = mkOption {
      type = types.nullOr (types.listOf types.str);
      default = null;
      description = documentDefault description strongswanDefault;
    };
    render = single (value: concatStringsSep sep value);
  };

  mkAttrsOfParams = params :
    mkAttrsOf params (types.submodule {options = paramsToOptions params;});

  mkAttrsOfParam = param :
    mkAttrsOf param param.option.type;

  mkAttrsOf = param : option : description : {
    _type = "param";
    option = mkOption {
      type = types.attrsOf option;
      default = {};
      inherit description;
    };
    render = single (attrs:
      (paramsToRenderedStrings attrs
        (mapAttrs (_n: _v: param) attrs)));
  };

  mkPrefixedAttrsOfParams = params :
    mkPrefixedAttrsOf params (types.submodule {options = paramsToOptions params;});

  mkPrefixedAttrsOfParam = param :
    mkPrefixedAttrsOf param param.option.type;

  mkPrefixedAttrsOf = p : option : description : {
    _type = "param";
    option = mkOption {
      type = types.attrsOf option;
      default = {};
      inherit description;
    };
    render = prefix: attrs:
      let prefixedAttrs = mapAttrs' (name: nameValuePair "${prefix}-${name}") attrs;
      in paramsToRenderedStrings prefixedAttrs
           (mapAttrs (_n: _v: p) prefixedAttrs);
  };

  mkPostfixedAttrsOfParams = params : description : {
    _type = "param";
    option = mkOption {
      type = types.attrsOf (types.submodule {options = paramsToOptions params;});
      default = {};
      inherit description;
    };
    render = postfix: attrs:
      let postfixedAttrs = mapAttrs' (name: nameValuePair "${name}-${postfix}") attrs;
      in paramsToRenderedStrings postfixedAttrs
           (mapAttrs (_n: _v: params) postfixedAttrs);
  };

}
