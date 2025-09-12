{ lib }:
{
  /**
    Creates a Field attribute set. mkField accepts an attribute set with the following keys:

     Example:
       mkField { }  // => { _type = "field"; }
       mkField { default = "foo"; } // => { _type = "field"; default = "foo"; }
       mkField { optional = true; } // => { _type = "field"; optional = true; }
  */
  mkField =
    {
      # Default value used when no definition is given in the configuration.
      default ? null,
      # Textual representation of the default, for the manual.
      defaultText ? null,
      # Example value used in the manual.
      example ? null,
      # String describing the field.
      description ? null,
      # Related packages used in the manual (see `genRelatedPackages` in ../nixos/lib/make-fields-doc/default.nix).
      relatedPackages ? null,
      # Option type, providing type-checking and value merging.
      type ? null,
      # Whether the field is for NixOS developers only.
      internal ? null,
      # Whether the field shows up in the manual. Default: true. Use false to hide the field and any sub-options from submodules. Use "shallow" to hide only sub-options.
      visible ? null,
      # Whether the field is omitted from the final record when undefined. Default false.
      optional ? null,
    }@attrs:
    attrs // { _type = "field"; };
}
