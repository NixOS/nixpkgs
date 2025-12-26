{ lib }:

let
  inherit (lib) mkOption;
  inherit (lib.types)
    either
    enum
    nullOr
    port
    submodule
    ;
  mkPortOption =
    {
      optional ? false,
    }:
    mkOption {
      type =
        let
          type = either port (submodule {
            options = {
              from = mkOption { type = port; };
              to = mkOption { type = port; };
            };
          });
        in
        if optional then (nullOr type) else type;
      description = "";
      apply =
        value: if builtins.isAttrs value then "${toString value.from}-${toString value.to}" else value;
    };
  protocolOption = mkOption {
    type = enum [
      "tcp"
      "udp"
      "sctp"
      "dccp"
    ];
    description = "";
  };
in
{
  inherit mkPortOption;
  inherit protocolOption;

  toXmlAttrs = lib.mapAttrs' (name: lib.nameValuePair ("@" + name));
  mkXmlAttr = name: value: { "@${name}" = value; };
  filterNullAttrs = lib.filterAttrsRecursive (_: value: value != null);

  portProtocolOptions = {
    options = {
      port = mkPortOption { };
      protocol = protocolOption;
    };
  };
}
