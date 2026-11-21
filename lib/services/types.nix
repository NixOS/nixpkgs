{ lib, ... }:

let
  inherit (lib) mkOptionType mergeUniqueOption;

  /**
    The type of a reference to a modular service, used for
    `identity.sameUser`.

    Any modular service configuration is a valid value: the built-in
    `absoluteServicePath` option serves as the tag that identifies it as one.
    This is the same idiom as nixops4's resource reference type, which checks
    for its `absoluteMemberPath` option.
  */
  modularServiceReference = mkOptionType {
    name = "modular-service-reference";
    description = "modular service reference";
    descriptionClass = "noun";
    check = value: value ? absoluteServicePath;
    merge = mergeUniqueOption {
      message = "A modular service reference cannot be merged.";
    };
  };
in
{
  inherit modularServiceReference;
}
