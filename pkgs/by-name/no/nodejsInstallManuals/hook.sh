# shellcheck shell=bash

nodejsInstallManuals() {
    local -r packageJson="${1-./package.json}"

    local -r packageOut="$out/lib/node_modules/$(@jq@ --raw-output '.name' package.json)"

    while IFS= read -r man; do
        installManPage "$packageOut/$man"
    done < <(@jq@ --raw-output '(.man | type) as $typ | if $typ == "string" then .man
        elif $typ == "list" then .man | join("\n")
        elif $typ == "null" then empty
        else "invalid type " + $typ | halt_error end' "$packageJson")
}
