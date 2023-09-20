wine_url_base=https://dl.winehq.org/wine

sed_exprs=()

get_source_attr() {
    nix-instantiate --eval --json -E "(let pkgs = import ./. {}; in pkgs.callPackage $sources_file { inherit pkgs; }).$1" | jq -r
}

set_source_attr() {
    path="$1"
    name="$2"
    value="$3"
    line=$(nix-instantiate --eval -E "(builtins.unsafeGetAttrPos \"$name\" (let pkgs = import ./. {}; in pkgs.callPackage $sources_file { inherit pkgs; }).$path).line")
    sed_exprs+=(-e "${line}s@[^ ].*\$@$name = $value;@")
}

set_version_and_hash() {
    set_source_attr "$1" version "\"$2\""
    set_source_attr "$1" hash "\"$(to_sri "$3")\""
}

get_latest_wine_version() {
    list-directory-versions --pname=wine --url="$wine_url_base/source/$1" | grep -v 'diff\|rc\|tar' | sort --reverse --version-sort -u | head -n 1
}

get_latest_lib_version() {
    curl -s "$wine_url_base/$1/" | grep -o 'href="[0-9.]*/"' | sed 's_^href="\(.*\)/"_\1_' | sort --reverse --version-sort -u | head -n 1
}

to_sri() {
    nix --extra-experimental-features nix-command hash to-sri --type sha256 "$1"
}

autobump() {
    attr="$1"
    latest="$2"
    fetcher="${3:-nix-prefetch-url}"
    more="${4:-}"
    version=$(get_source_attr "$attr.version")
    if [[ "$version" != "$latest" ]]; then
        url=$(get_source_attr "$attr.url")
        set_version_and_hash "$attr" "$latest" "$($fetcher "${url//$version/$latest}")"
        [[ -z "$more" ]] || $more "$version" "$latest"
    fi
}

do_update() {
    [[ "${#sed_exprs[@]}" -eq 0 ]] || sed -i "${sed_exprs[@]}" "$sources_file"
}
