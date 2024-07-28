# stolen from https://github.com/NixOS/nixpkgs/pull/234651
# TODO switch to functions in that PR once it is merged

{ lib }:

let
  inherit (lib)
    setFunctionArgs
    id
    functionArgs
    optionalAttrs
    toFunction
    ;
in
{

  extendMkDerivation =
    {
      modify ? id,
      inheritFunctionArgs ? true,
    }:
    mkDerivationBase: attrsOverlay:
    setFunctionArgs
      # Adds the fixed-point style support.
      (fpargs: modify ((mkDerivationBase fpargs).overrideAttrs attrsOverlay))
      # Add __functionArgs
      (
        # Inherit the __functionArgs from the base build helper
        functionArgs (attrsOverlay { })
        # Recover the __functionArgs from the derived build helper
        // optionalAttrs inheritFunctionArgs (functionArgs mkDerivationBase)
      )
    // {
      # Passthru attributes attached to the result build helper.
      attrsOverlays = mkDerivationBase.attrsOverlays or [ ] ++ [ attrsOverlay ];
    };

  adaptMkDerivation =
    {
      modify ? id,
      inheritFunctionArgs ? true,
    }:
    mkDerivationBase: adaptArgs:
    setFunctionArgs
      # Adds the fixed-point style support
      (
        fpargs: modify (mkDerivationBase (finalAttrs: adaptArgs finalAttrs (toFunction fpargs finalAttrs)))
      )
      # Add __functionArgs
      (
        # Inherit the __functionArgs from the base build helper
        optionalAttrs inheritFunctionArgs (functionArgs mkDerivationBase)
        # Recover the __functionArgs from the derived build helper
        // functionArgs (adaptArgs { })
      );
}
