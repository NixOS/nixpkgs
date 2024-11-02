{ lib, config, ... }:

with lib;
let
  mergeFalseByDefault = locs: defs:
    if defs == [] then abort "This case should never happen."
    else if any (x: x == false) (getValues defs) then false
    else true;

  kernelItem = types.submodule {
    options = {
      tristate = mkOption {
        type = types.enum [ "y" "m" "n" null ];
        default = null;
        internal = true;
        visible = true;
        description = ''
          Use this field for tristate kernel options expecting a "y" or "m" or "n".
        '';
      };

      freeform = mkOption {
        type = types.nullOr types.str // {
          merge = mergeEqualOption;
        };
        default = null;
        example = ''MMC_BLOCK_MINORS.freeform = "32";'';
        description = ''
          Freeform description of a kernel configuration item value.
        '';
      };

      optional = mkOption {
        type = types.bool // { merge = mergeFalseByDefault; };
        default = false;
        description = ''
          Whether option should generate a failure when unused.
          Upon merging values, mandatory wins over optional.
        '';
      };
    };
  };

  mkValue = with lib; val:
  let
    isNumber = c: elem c ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9"];

  in
    if (val == "") then "\"\""
    else if val == "y" || val == "m" || val == "n" then val
    else if all isNumber (stringToCharacters val) then val
    else if substring 0 2 val == "0x" then val
    else val; # FIXME: fix quoting one day


  # generate nix intermediate kernel config file of the form
  #
  #       VIRTIO_MMIO m
  #       VIRTIO_BLK y
  #       VIRTIO_CONSOLE n
  #       NET_9P_VIRTIO? y
  #
  # Borrowed from copumpkin https://github.com/NixOS/nixpkgs/pull/12158
  # returns a string, expr should be an attribute set
  # Use mkValuePreprocess to preprocess option values, aka mark 'modules' as 'yes' or vice-versa
  # use the identity if you don't want to override the configured values
  generateNixKConf = exprs:
  let
    mkConfigLine = key: item:
      let
        val = if item.freeform != null then item.freeform else item.tristate;
      in
        optionalString (val != null)
            (if (item.optional)
            then "${key}? ${mkValue val}\n"
            else "${key} ${mkValue val}\n");

    mkConf = cfg: concatStrings (mapAttrsToList mkConfigLine cfg);
  in mkConf exprs;

in
{

  options = {

    intermediateNixConfig = mkOption {
      readOnly = true;
      type = types.lines;
      example = ''
        USB? y
        DEBUG n
      '';
      description = ''
        The result of converting the structured kernel configuration in settings
        to an intermediate string that can be parsed by generate-config.pl to
        answer the kernel `make defconfig`.
      '';
    };

    settings = mkOption {
      type = types.attrsOf kernelItem;
      example = literalExpression '' with lib.kernel; {
        "9P_NET" = yes;
        USB = option yes;
        MMC_BLOCK_MINORS = freeform "32";
      }'';
      description = ''
        Structured kernel configuration.
      '';
    };
  };

  config = {
    intermediateNixConfig = generateNixKConf config.settings;
  };
}
