{
  lib,
  nautilus,
  callPackage,
}:

nautilus.overrideAttrs (
  finalAttrs:
  _prevAttrs@{
    patches ? [ ],
    passthru ? { },
    meta ? { },
    ...
  }:
  {
    pname = "nautilus-typeahead";
    passthru = passthru // {
      updateScript = ./update.sh;
      typeaheadPatch = (callPackage ./patch.nix { });
    };

    patches = [ finalAttrs.passthru.typeaheadPatch ] ++ patches;

    meta = meta // {
      description = meta.description + " - patched to bring back 'typeahead find'";
      maintainers = with lib.maintainers; [ bryango ];
    };
  }
)
