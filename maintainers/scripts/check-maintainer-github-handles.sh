#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq parallel

# Example how to work with the `lib.maintainers` attrset.
# Can be used to check whether all user handles are still valid.

set -e

# checks whether a user handle can be found on github
function checkUser {
    local user="$1"
    local status=
    status="$(curl --silent --head "https://github.com/${user}" | grep Status)"
    printf "%s\t\t\t\t%s\n" "$status" "$user"
}
export -f checkUser

# output the maintainers set as json
# and filter out the github username of each maintainer (if it exists)
# then check 100 at the same time
nix-instantiate -A lib.maintainers --eval --strict --json \
    | jq -r '.[]|.github' \
    | parallel -j100 checkUser
