{ lib }:
with lib.strings;
with lib.types;
with lib.options;
rec {


  # A type for paths containing secrets
  secretPath = mkOptionType {
    name = "secret path";
    check = x: path.check x && (
      # Secrets shouldn't be path literals because those could be copied into the store
      # Secrets also shouldn't be in /nix/store through other means
      builtins.typeOf x != "path" && ! hasPrefix builtins.storeDir (toString x)
      # Unless this is explicitly wanted with secretInNixStore
      || x._secretInNixStore or false);
    checkFailedMessage = x: optionalString (path.check x) "If you want to import the secret into the globally readable Nix store, use lib.secretInNixStore on the value.";
    # mergeEqualOption does strictly evaluate all definitions, which can
    # import paths into /nix/store, but this isn't a problem, since all
    # definitions will have been checked already, so only paths that *should*
    # be imported into the store will be evaluated here, namely the ones
    # marked with secretInNixStore
    merge = loc: defs: protectPath loc (mergeEqualOption loc defs);
  };

  /* Explicitly define a secret path in the world-readable Nix store, allowing
     it to be used as a value for options of type secretPath.
  */
  secretInNixStore = path:
    let
      storePath =
        # Type is a literal path, indicating the path to exist in the evaluation
        # hosts Nix store
        if builtins.typeOf path == "path" then
          # Don't import again if the path refers to something in the store
          # We do this so that secrets aren't stored multiple times in the store
          if hasPrefix builtins.storeDir (toString path) then
            builtins.storePath path
          # Otherwise import the path into the store
          # We could just use string interpolation to do this, but that wouldn't
          # work with invalid-as-derivation-name filenames
          else builtins.path {
            name = validDerivationName (baseNameOf path);
            path = path;
          }
        # It's not a literal path, meaning it's something string-like, either
        # - Without context: It's a store path the evaluation host doesn't know
        #   about, but the target host will
        # - With context: It's a store path the evaluation host will build and
        #   transfer to the target host
        else if hasPrefix builtins.storeDir (toString path) then
          # Both above cases can be handled by just passing along the path
          # directly
          path
        # The path is neither a /nix/store path nor is it a literal path,
        # meaning there's no way to put this path into the store
        else throw ("secretInNixStore: The path '${toString path}' can't be in "
          + "the Nix store. You probably don't need to use secretInNixStore for "
          + "this path.");
    # Evaluate the path right away to trigger the error early
    in builtins.seq storePath {
      # Set outPath such interpolating this string yields the store path
      outPath = storePath;
      _secretInNixStore = true;
    };


  protectPath = loc: path: {
    __toString = throw "The value of `${lib.concatStringsSep "." loc}' is a protected path to a secret, which needs to be explicitly unprotected with `lib.unprotectPath' in order to be usable.";
    # Argument such that it doesn't get called by any automatic means
    wrappedPath = { _nixos_protected_path }: path;
  };

  unprotectPath = protectedPath: protectedPath.wrappedPath {
    _nixos_protected_path = null;
  };

}
