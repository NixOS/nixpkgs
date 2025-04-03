{
  lib,
  runCommand,
  jq,
  yq,
}:

{
  pname ? null,

  # A list of dependency package names.
  dependencies,

  # An attribute set of package names to sources.
  dependencySources,
}:

let
  packages = lib.genAttrs dependencies (dependency: rec {
    src = dependencySources.${dependency};
    inherit (src) packageRoot;
  });
in
(runCommand "${lib.optionalString (pname != null) "${pname}-"}package-config.json" {
  inherit packages;

  nativeBuildInputs = [
    jq
    yq
  ];

  __structuredAttrs = true;
})
  ''
    declare -A packageSources
    declare -A packageRoots
    while IFS=',' read -r name src packageRoot; do
      packageSources["$name"]="$src"
      packageRoots["$name"]="$packageRoot"
    done < <(jq -r '.packages | to_entries | map("\(.key),\(.value.src),\(.value.packageRoot)") | .[]' "$NIX_ATTRS_JSON_FILE")

    for package in "''${!packageSources[@]}"; do
      if [ ! -e "''${packageSources["$package"]}/''${packageRoots["$package"]}/pubspec.yaml" ]; then
        echo >&2 "The package sources for $package are missing. Is the following path inside the source derivation?"
        echo >&2 "Source path: ''${packageSources["$package"]}/''${packageRoots["$package"]}/pubspec.yaml"
        exit 1
      fi

      languageConstraint="$(yq -r .environment.sdk "''${packageSources["$package"]}/''${packageRoots["$package"]}/pubspec.yaml")"
      if [[ "$languageConstraint" =~ ^[[:space:]]*(\^|>=|>)?[[:space:]]*([[:digit:]]+\.[[:digit:]]+)\.[[:digit:]]+.*$ ]]; then
        languageVersionJson="\"''${BASH_REMATCH[2]}\""
      elif [ "$languageConstraint" = 'any' ]; then
        languageVersionJson='null'
      else
        # https://github.com/dart-lang/pub/blob/68dc2f547d0a264955c1fa551fa0a0e158046494/lib/src/language_version.dart#L106C35-L106C35
        languageVersionJson='"2.7"'
      fi

      jq --null-input \
        --arg name "$package" \
        --arg path "''${packageSources["$package"]}/''${packageRoots["$package"]}" \
        --argjson languageVersion "$languageVersionJson" \
        '{
          name: $name,
          rootUri: "file://\($path)",
          packageUri: "lib/",
          languageVersion: $languageVersion,
        }'
    done | jq > "$out" --slurp '{
      configVersion: 2,
      generator: "nixpkgs",
      packages: .,
    }'
  ''
