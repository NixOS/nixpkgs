{ lib, config, ... }:

with lib;
let
  findWinner = candidates: winner:
    any (x: x == winner) candidates;

  # winners is an ordered list where first item wins over 2nd etc
  mergeAnswer = winners: locs: defs:
    let
      values = map (x: x.value) defs;
      freeformAnswer = intersectLists values winners;
      inter = intersectLists values winners;
      winner = head winners;
    in
    if defs == [] then abort "This case should never happen."
    else if winner == [] then abort "Give a valid list of winner"
    else if inter == [] then mergeOneOption locs defs
    else if findWinner values winner then
      winner
    else
      mergeAnswer (tail winners) locs defs;

  mergeFalseByDefault = locs: defs:
    if defs == [] then abort "This case should never happen."
    else if any (x: x == false) defs then false
    else true;

  kernelItem = types.submodule {
    options = {
      tristate = mkOption {
        type = types.enum [ "y" "m" "n" null ] // {
          merge = mergeAnswer [ "y" "m" "n" ];
        };
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
          Wether option should generate a failure when unused.
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
        if val == null
          then ""
          else if (item.optional)
            then "${key}? ${mkValue val}\n"
            else "${key} ${mkValue val}\n";

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
      example = literalExample '' with lib.kernel; {
        "9P_NET" = yes;
        USB = optional yes;
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
