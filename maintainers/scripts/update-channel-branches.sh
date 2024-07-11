#!/usr/bin/env bash
set -e

: ${NIXOS_CHANNELS:=https://nixos.org/channels/}
: ${CHANNELS_NAMESPACE:=refs/heads/channels/}

# List all channels which are currently in the repository which we would
# have to remove if they are not found again.
deadChannels=$(git for-each-ref --format="%(refname)" "$CHANNELS_NAMESPACE")

updateRef() {
    local channelName=$1
    local newRev=$2

    # if the inputs are not valid, then we do not update any branch.
    test -z "$newRev" -o -z "$channelName" && return;

    # Update the local refs/heads/channels/* branches to be in-sync with the
    # channel references.
    local branch=$CHANNELS_NAMESPACE$channelName
    oldRev=$(git rev-parse --short "$branch" 2>/dev/null || true)
    if test "$oldRev" != "$newRev"; then
        if git update-ref "$branch" "$newRev" 2>/dev/null; then
            if test -z "$oldRev"; then
                echo " * [new branch]      $newRev           -> ${branch#refs/heads/}"
            else
                echo "                     $oldRev..$newRev  -> ${branch#refs/heads/}"
            fi
        else
            if test -z "$oldRev"; then
                echo " * [missing rev]     $newRev           -> ${branch#refs/heads/}"
            else
                echo "   [missing rev]     $oldRev..$newRev  -> ${branch#refs/heads/}"
            fi
        fi
    fi

    # Filter out the current channel from the list of dead channels.
    deadChannels=$(grep -v "$CHANNELS_NAMESPACE$channelName" <<EOF
$deadChannels
EOF
) ||true
}

# Find the name of all channels which are listed in the directory.
echo "Fetching channels from $NIXOS_CHANNELS:"
for channelName in : $(curl -s "$NIXOS_CHANNELS" | sed -n '/folder/ { s,.*href=",,; s,/".*,,; p }'); do
    test "$channelName" = : && continue;

    # Do not follow redirections, such that we can extract the
    # short-changeset from the name of the directory where we are
    # redirected to.
    sha1=$(curl -sI "$NIXOS_CHANNELS$channelName" | sed -n '/Location/ { s,.*\.\([a-f0-9]*\)[ \r]*$,\1,; p; }')

    updateRef "remotes/$channelName" "$sha1"
done

echo "Fetching channels from nixos-version:"
if currentSystem=$(nixos-version 2>/dev/null); then
    # If the system is entirely build from a custom nixpkgs version,
    # then the version is not annotated in git version. This sed
    # expression is basically matching that the expressions end with
    # ".<sha1> (Name)" to extract the sha1.
    sha1=$(echo "$currentSystem" | sed -n 's,^.*\.\([a-f0-9]*\) *(.*)$,\1,; T skip; p; :skip;')

    updateRef current-system "$sha1"
fi

echo "Fetching channels from $HOME/.nix-defexpr:"
for revFile in : $(find -L "$HOME/.nix-defexpr/" -maxdepth 4 -name svn-revision); do
    test "$revFile" = : && continue;

    # Deconstruct a path such as, into:
    #
    #   /home/luke/.nix-defexpr/channels_root/nixos/nixpkgs/svn-revision
    #     channelName = root/nixos
    #
    #   /home/luke/.nix-defexpr/channels/nixpkgs/svn-revision
    #     channelName = nixpkgs
    #
    user=${revFile#*.nix-defexpr/channels}
    repo=${user#*/}
    repo=${repo%%/*}
    user=${user%%/*}
    user=${user#_}
    test -z "$user" && user=$USER
    channelName="$user${user:+/}$repo"

    sha1=$(sed -n 's,^.*\.\([a-f0-9]*\)$,\1,; T skip; p; :skip;' "$revFile")

    updateRef "$channelName" "$sha1"
done

# Suggest to remove channel branches which are no longer found by this
# script. This is to handle the cases where a local/remote channel
# disappear. We should not attempt to remove manually any branches, as they
# might be user branches.
if test -n "$deadChannels"; then

    echo "
Some old channel branches are still in your repository, if you
want to remove them, run the following command(s):
"

    while read branch; do
        echo "    git update-ref -d $branch"
    done <<EOF
$deadChannels
EOF

    echo
fi
