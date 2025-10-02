{
  lib,
  stdenv,
  callPackage,
}:

let
  package =
    if stdenv.hostPlatform.isDarwin then callPackage ./darwin.nix { } else callPackage ./linux.nix { };
in

package.overrideAttrs (
  finalAttrs: oldAttrs: {
    passthru = {
      updateScript = ./update.sh;
    }
    // oldAttrs.passthru or { };

    # Point `nix edit`, etc. to the file that defines the attribute, not this
    # entry point
    pos = builtins.unsafeGetAttrPos "pname" finalAttrs;

    meta = {
      description = "Easy to get into fully moddable First Person Shooter with advanced movement mechanics";
      homepage = "https://krunker.io";
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [ getchoo ];
      mainProgram = "krunker";
      platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    }
    // oldAttrs.meta or { };
  }
)
