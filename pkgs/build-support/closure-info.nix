{
  stdenvNoCC,
  coreutils,
  jq,
}:

/**
  Produces metadata about the closure of the given root paths.

  1. Total NAR size in `$out/total-nar-size`.
  2. Registration, suitable for `nix-store --load-db`, in `$out/registration`.
     Can also be used with `nix-store --register-validity --hash-given`.
  3. All store paths for the closure in `$out/store-paths`.

  # Inputs

  `rootPaths` ([Path])

  : List of root paths to include in the closure information.

  # Type

  ```
  closureInfo :: { rootPaths :: [Path]; } -> Derivation
  ```

  # Examples
  :::{.example}
  ## `pkgs.closureInfo` usage example
  ```
  pkgs.closureInfo {
    rootPaths = [ pkgs.hello pkgs.bc pkgs.dwarf2json ];
  }
  =>
  «derivation /nix/store/...-closure-info.drv»
  ```

  :::
*/
{ rootPaths }:

assert builtins.langVersion >= 5;

stdenvNoCC.mkDerivation {
  name = "closure-info";

  __structuredAttrs = true;

  exportReferencesGraph.closure = rootPaths;

  preferLocalBuild = true;

  nativeBuildInputs = [
    coreutils
    jq
  ];

  empty = rootPaths == [ ];

  buildCommand = ''
    out=''${outputs[out]}

    mkdir $out

    if [[ -n "$empty" ]]; then
      echo 0 > $out/total-nar-size
      touch $out/registration $out/store-paths
    else
      jq -r ".closure | map(.narSize) | add" < "$NIX_ATTRS_JSON_FILE" > $out/total-nar-size
      jq -r '.closure | map([.path, .narHash, .narSize, "", (.references | length)] + .references) | add | map("\(.)\n") | add' < "$NIX_ATTRS_JSON_FILE" | head -n -1 > $out/registration
      jq -r '.closure[].path' < "$NIX_ATTRS_JSON_FILE" > $out/store-paths
    fi

  '';
}
