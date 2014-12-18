#!/bin/sh

: ${NIXOS_CHANNELS:=https://nixos.org/channels/}

# Find the name of all channels which are listed in the directory.
for channelName in : $(curl -s $NIXOS_CHANNELS | sed -n '/folder/ { s,.*href=",,; s,/".*,,; p }'); do
    test "$channelName" = : && continue;

    # Do not follow redirections, such that we can extract the
    # short-changeset from the name of the directory where we are
    # redirected to.
    sha1=$(curl -sI $NIXOS_CHANNELS$channelName | sed -n '/Location/ { s,.*\.\([a-f0-9]*\)[ \r]*$,\1,; p; }')
    test -z "$sha1" -o -z "$channelName" && continue;

    # Update the local refs/heads/channels/remotes/* branches to be
    # in-sync with the channel references.
    git update-ref refs/heads/channels/remotes/$channelName $sha1
done

if currentSystem=$(nixos-version 2>/dev/null); then
    channelName=current-system

    # If the system is entirely build from a custom nixpkgs version,
    # then the version is not annotated in git version. This sed
    # expression is basically matching that the expressions end with
    # ".<sha1> (Name)" to extract the sha1.
    sha1=$(echo $currentSystem | sed -n 's,^.*\.\([a-f0-9]*\) *(.*)$,\1,; T skip; p; :skip;')
    if test -n "$sha1"; then

        # Update the local refs/heads/channels/locals/* branches to be
        # in-sync with the channel references.
        git update-ref refs/heads/channels/locals/$channelName $sha1
    fi
fi

for revFile in : $(find -L ~/.nix-defexpr/ -maxdepth 4 -name svn-revision); do
    test "$revFile" = : && continue;

    # Deconstruct a path such as, into:
    #   /home/luke/.nix-defexpr/channels_root/nixos/nixpkgs/svn-revision
    #     user=root  repo=nixos    channelName=root/nixos
    #
    #   /home/luke/.nix-defexpr/channels/nixpkgs/svn-revision
    #     user=luke  repo=nixpkgs  channelName=luke/nixpkgs
    user=${revFile#*.nix-defexpr/channels}
    repo=${user#*/}
    repo=${repo%%/*}
    user=${user%%/*}
    user=${user#_}
    test -z "$user" && user=$USER
    channelName="$user/$repo"

    sha1=$(cat $revFile | sed -n 's,^.*\.\([a-f0-9]*\)$,\1,; T skip; p; :skip;')
    test -z "$sha1" -o -z "$channelName" && continue;

    # Update the local refs/heads/channels/locals/* branches to be
    # in-sync with the channel references.
    git update-ref refs/heads/channels/locals/$channelName $sha1
done
