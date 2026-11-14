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
    version ? "",
    ...
  }:
  {
    pname = "nautilus-typeahead";
    passthru = passthru // {
      updateScript = ./update.sh;
      typeaheadPatch = (callPackage ./patch.nix { });
    };

    version =
      let
        inherit (finalAttrs.passthru.typeaheadPatch) pkgver;
      in
      lib.warnIf (pkgver != version) ''
        ${finalAttrs.pname}: Nautilus version for the AUR patch "${pkgver}"
        is not the same as Nixpkgs Nautilus version "${version}"!
        This may lead to patch failures.
      '' version;

    patches = [ finalAttrs.passthru.typeaheadPatch ] ++ patches;

    meta = meta // {
      description = meta.description + " - patched to bring back 'typeahead find'";
      maintainers = with lib.maintainers; [ bryango ];
    };
  }
)
