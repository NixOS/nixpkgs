# shellcheck shell=bash

nodejsInstallExecutables() {
    local -r packageJson="${1-./package.json}"

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' package.json)"

    local -a user_args=()

    if [[ -v makeWrapperArgs ]]; then
      concatTo user_args makeWrapperArgs
    fi

    while IFS=" " read -ra bin; do
        mkdir -p "$out/bin"
        makeWrapper @hostNode@ "$out/bin/${bin[0]}" --add-flags "$packageOut/${bin[1]}" "${user_args[@]}"
    done < <(@jq@ --raw-output '(.bin | type) as $typ | if $typ == "string" then
        .name + " " + .bin
        elif $typ == "object" then .bin | to_entries | map(.key + " " + .value) | join("\n")
        elif $typ == "null" then empty
        else "invalid type " + $typ | halt_error end' "$packageJson")
}
