{ lib, stdenvNoCC }:

/**
  `replaceVarsWith` is a wrapper around the [bash function `substitute`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute)
  in the stdenv. It allows for terse replacement of names in the specified path, while checking
  for common mistakes such as naming a replacement that does nothing or forgetting a variable which
  needs to be replaced.

  As with the [`--subst-var-by`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute-subst-var-by)
  flag, names are encoded as `@name@` in the provided file at the provided path.

  Any unmatched variable names in the file at the provided path will cause a build failure.

  By default, any remaining text that matches `@[A-Za-z_][0-9A-Za-z_'-]@` in the output after replacement
  has occurred will cause a build failure. Variables can be excluded from this check by passing "null" for them.

  # Inputs

  `src` ([Store Path](https://nixos.org/manual/nix/latest/store/store-path.html#store-path) String)
  : The file in which to replace variables.

  `replacements` (AttrsOf String)
  : Each entry in this set corresponds to a `--subst-var-by` entry in [`substitute`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute) or
    null to keep it unchanged.

  `dir` (String)
  : Sub directory in $out to store the result in. Commonly set to "bin".

  `isExecutable` (Boolean)
  : Whether to mark the output file as executable.

  Most arguments supported by mkDerivation are also supported, with some exceptions for which
  an error will be thrown.

  # Example

  ```nix
  { replaceVarsWith }:

  replaceVarsWith {
    src = ./my-setup-hook.sh;
    replacements = { world = "hello"; };
    dir = "bin";
    isExecutable = true;
  }
  ```

  See `../../test/replace-vars/default.nix` for tests of this function. Also see `replaceVars` for a short
  version with src and replacements only.
*/
{
  src,
  replacements,
  dir ? null,
  isExecutable ? false,
  ...
}@attrs:

let
  # We use `--replace-fail` instead of `--subst-var-by` so that if the thing isn't there, we fail.
  subst-var-by = name: value: [
    "--replace-fail"
    (lib.escapeShellArg "@${name}@")
    (lib.escapeShellArg (lib.defaultTo "@${name}@" value))
  ];

  substitutions = lib.concatLists (lib.mapAttrsToList subst-var-by replacements);

  left-overs = map ({ name, ... }: name) (
    builtins.filter ({ value, ... }: value == null) (lib.attrsToList replacements)
  );

  optionalAttrs =
    if (builtins.intersectAttrs attrs forcedAttrs == { }) then
      removeAttrs attrs [ "replacements" ]
    else
      throw "Passing any of ${builtins.concatStringsSep ", " (builtins.attrNames forcedAttrs)} to replaceVarsWith is not supported.";

  forcedAttrs = {
    doCheck = true;
    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      target=$out
      if test -n "$dir"; then
          target=$out/$dir/$name
          mkdir -p $out/$dir
      fi

      substitute "$src" "$target" ${lib.concatStringsSep " " substitutions}

      if test -n "$isExecutable"; then
          chmod +x $target
      fi

      runHook postBuild
    '';

    # Look for Nix identifiers surrounded by `@` that aren't substituted.
    checkPhase =
      let
        lookahead =
          if builtins.length left-overs == 0 then "" else "(?!${builtins.concatStringsSep "|" left-overs}@)";
        regex = lib.escapeShellArg "@${lookahead}[a-zA-Z_][0-9A-Za-z_'-]*@";
      in
      ''
        runHook preCheck
        if grep -Pqe ${regex} "$target"; then
          echo The following look like unsubstituted Nix identifiers that remain in "$target":
          grep -Poe ${regex} "$target"
          echo Use the more precise '`substitute`' function if this check is in error.
          exit 1
        fi
        runHook postCheck
      '';
  };
in

stdenvNoCC.mkDerivation (
  {
    name = baseNameOf (toString src);
  }
  // optionalAttrs
  // forcedAttrs
)
