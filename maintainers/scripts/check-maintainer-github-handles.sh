#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq parallel

# Example how to work with the `lib.maintainers` attrset.
# Can be used to check whether all user handles are still valid.

set -o errexit -o noclobber -o nounset -o pipefail
shopt -s failglob inherit_errexit

function checkCommits {
    local ret status tmp user
    user="$1"
    tmp=$(mktemp)
    curl --silent -w "%{http_code}" \
         "https://github.com/NixOS/nixpkgs/commits?author=$user" \
         > "$tmp"
    # the last line of tmp contains the http status
    status=$(tail -n1 "$tmp")
    ret=
    case $status in
        200) if <"$tmp" grep -i "no commits found" > /dev/null; then
                 ret=1
             else
                 ret=0
             fi
             ;;
        # because of github’s hard request limits, this can take some time
        429) sleep 2
             printf "."
             checkCommits "$user"
             ret=$?
             ;;
        *)   printf "BAD STATUS: $(tail -n1 "$tmp") for %s\n" "$user"; ret=1
             ret=1
             ;;
    esac
    rm "$tmp"
    return $ret
}
export -f checkCommits

function checkUser {
    local user="$1"
    local status=
    status="$(curl --silent --head "https://github.com/${user}" | grep Status)"
    # checks whether a user handle can be found on github
    if [[ "$status" =~ 404 ]]; then
        printf "%s\t\t\t\t%s\n" "$status" "$user"
    # checks whether the user handle has any nixpkgs commits
    elif checkCommits "$user"; then
        printf "OK!\t\t\t\t%s\n" "$user"
    else
        printf "No Commits!\t\t\t%s\n" "$user"
    fi
}
export -f checkUser

# output the maintainers set as json
# and filter out the github username of each maintainer (if it exists)
# then check some at the same time
nix-instantiate -A lib.maintainers --eval --strict --json \
    | jq -r '.[]|.github|select(.)' \
    | parallel -j5 checkUser

# To check some arbitrary users:
# parallel -j100 checkUser ::: "eelco" "profpatsch" "Profpatsch" "a"
