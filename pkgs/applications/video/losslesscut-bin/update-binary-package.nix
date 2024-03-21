{ lib
, writeShellApplication
, gnused
, jo
, lastversion
, nix-prefetch
}:

let
  concatMapStringAttrsSep = sep: f: attrs:
    lib.concatMapStringsSep sep (name: f name attrs.${name}) (lib.attrNames attrs);
in
lib.makeOverridable (
{ attrPath ? null
, filesToOverride
, formatAttrNames
, prefetchHashAlgo ? "sha256"
, repoUrl
, fetchVersionCommand ? [ "lastversion" repoUrl ]
}@args:
let
  updateScriptBin = writeShellApplication {
    name = "update-binary-package";
    runtimeInputs = [
      gnused
      jo
      lastversion
      nix-prefetch
    ];
    text = ''
      set -x
      ${concatMapStringAttrsSep "\n" lib.toShellVar ({
        inherit
          formatAttrNames
          prefetchHashAlgo
          ;
      })}
      mainAttrPath="''$UPDATE_NIX_ATTR_PATH"
      oldVersion="''${UPDATE_NIX_OLD_VERSION:-$(nix --extra-experimental-features "nix-command" eval --impure --raw --expr "(import ./. { }).$mainAttrPath.version")}"
      newVersion="''${VERSION:-$(${if lib.isList fetchVersionCommand then lib.escapeShellArgs fetchVersionCommand else fetchVersionCommand})}"
      filesToOverride=("$@")
      if [[ "$oldVersion" == "$newVersion" ]]; then
        echo "No version change detected. Both are $oldVersion." >&2
        echo []
        exit 0
      fi
      declare -a oldHashes=()
      for format in "''${formatAttrNames[@]}"; do
        oldHashes+=("$(nix --extra-experimental-features "nix-command" eval --impure --raw --expr "(import ./. { }).$mainAttrPath.$format.src.outputHash")")
      done
      for fileToOverride in "''${filesToOverride[@]}"; do
        sed -i "s#\"$oldVersion\"#\"$newVersion\"#g" "$fileToOverride"
      done
      declare -a newHashes=()
      for formatAttrName in "''${formatAttrNames[@]}"; do
        newHashes+=("$(nix-prefetch --expr "{ $prefetchHashAlgo }: ((import ./. { }).$mainAttrPath.$formatAttrName.override { hash = $prefetchHashAlgo; }).src")")
      done
      declare -a sedHashCommand=()
      for i in "''${!formatAttrNames[@]}"; do
        sedHashCommand+=(-e "s#''${oldHashes[$i]}#''${newHashes[$i]}#g")
      done
      for fileToOverride in "''${filesToOverride[@]}"; do
        sed -i "''${sedHashCommand[@]}" "$fileToOverride"
      done
      jo -p -a "$(jo -- \
        -s attrPath="$mainAttrPath" \
        -s oldVersion="$oldVersion" \
        -s newVersion="$newVersion" \
        files="$(jo -a "''${filesToOverride[@]}")" \
      )"
    '';
  };
in
{
  command = [
    (lib.getExe updateScriptBin)
  ] ++ filesToOverride;
  supportedFeatures = [
    "commit"
  ];
  # This is for debugging purpose.
  # Invoke the following command to see how  how the result updateScript work in real time:
  # UPDATE_NIX_ATTR_PATH=<attribute path> nix run .#<attribute path>.updateScript.updateScriptBin <files in need of update>
  inherit updateScriptBin; # for debugging purpose
} // lib.optionalAttrs (attrPath != null) {
  inherit attrPath;
})
