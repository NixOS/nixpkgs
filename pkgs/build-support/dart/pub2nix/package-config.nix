{ lib
, runCommand
, jq
, yq
}:

{ pname ? null

  # A list of dependency package names.
, dependencies

  # An attribute set of package names to sources.
, dependencySources
}:

let
  packages = lib.getAttrs dependencies dependencySources;
in
(runCommand "${lib.optionalString (pname != null) "${pname}-"}package-config.json" {
  inherit packages;

  nativeBuildInputs = [ jq yq ];

  __structuredAttrs = true;
}) ''
  declare -A packages
  while IFS='=' read -r name path; do
    packages["$name"]="$path"
  done < <(jq -r '.packages | to_entries | map("\(.key)=\(.value)") | .[]' "$NIX_ATTRS_JSON_FILE")

  jq > "$out" --slurp '{
    configVersion: 2,
    generator: "nixpkgs",
    packages: .,
  }' <(for package in "''${!packages[@]}"; do
      languageConstraint="$(yq -r .environment.sdk "''${packages["$package"]}/pubspec.yaml")"
      if [[ "$languageConstraint" =~ ^[[:space:]]*(\^|>=|>|)[[:space:]]*([[:digit:]]+\.[[:digit:]]+)\.[[:digit:]]+.*$ ]]; then
        languageVersionJson="\"''${BASH_REMATCH[2]}\""
      elif [ "$languageConstraint" = 'any' ]; then
        languageVersionJson='null'
      else
        # https://github.com/dart-lang/pub/blob/68dc2f547d0a264955c1fa551fa0a0e158046494/lib/src/language_version.dart#L106C35-L106C35
        languageVersionJson='"2.7"'
      fi

      jq --null-input \
        --arg name "$package" \
        --arg path "''${packages["$package"]}" \
        --argjson languageVersion "$languageVersionJson" \
        '{
          name: $name,
          rootUri: "file://\($path)",
          packageUri: "lib/",
          languageVersion: $languageVersion,
        }'
    done)
''
