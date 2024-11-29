{ lib, stdenvNoCC }:

/**
  `replaceVars` is a wrapper around the [bash function `substitute`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute)
  in the stdenv. It allows for terse replacement of names in the specified path, while checking
  for common mistakes such as naming a replacement that does nothing or forgetting a variable which
  needs to be replaced.

  As with the [`--subst-var-by`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute-subst-var-by)
  flag, names are encoded as `@name@` in the provided file at the provided path.

  Any unmatched variable names in the file at the provided path will cause a build failure.

  Any remaining text that matches `@[A-Za-z_][0-9A-Za-z_'-]@` in the output after replacement
  has occurred will cause a build failure.

  # Inputs

  `path` ([Store Path](https://nixos.org/manual/nix/latest/store/store-path.html#store-path) String)
  : The file in which to replace variables.

  `attrs` (AttrsOf String)
  : Each entry in this set corresponds to a `--subst-var-by` entry in [`substitute`](https://nixos.org/manual/nixpkgs/stable/#fun-substitute).

  # Example

  ```nix
  { replaceVars }:

  replaceVars ./greeting.txt { world = "hello"; }
  ```

  See `../../test/replace-vars/default.nix` for tests of this function.
*/
path: attrs:

let
  # We use `--replace-fail` instead of `--subst-var-by` so that if the thing isn't there, we fail.
  subst-var-by = name: value: [
    "--replace-fail"
    (lib.escapeShellArg "@${name}@")
    (lib.escapeShellArg value)
  ];

  replacements = lib.concatLists (lib.mapAttrsToList subst-var-by attrs);
in

stdenvNoCC.mkDerivation {
  name = baseNameOf (toString path);
  src = path;
  doCheck = true;
  dontUnpack = true;
  preferLocalBuild = true;
  allowSubstitutes = false;

  buildPhase = ''
    runHook preBuild
    substitute "$src" "$out" ${lib.concatStringsSep " " replacements}
    runHook postBuild
  '';

  # Look for Nix identifiers surrounded by `@` that aren't substituted.
  checkPhase =
    let
      regex = lib.escapeShellArg "@[a-zA-Z_][0-9A-Za-z_'-]*@";
    in
    ''
      runHook preCheck
      if grep -qe ${regex} "$out"; then
        echo The following look like unsubstituted Nix identifiers that remain in "$out":
        grep -oe ${regex} "$out"
        echo Use the more precise '`substitute`' function if this check is in error.
        exit 1
      fi
      runHook postCheck
    '';
}
