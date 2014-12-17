#!/bin/sh

: ${NIXOS_CHANNELS:=https://nixos.org/channels/}

# Find the name of all channels which are listed in the directory.
for channelName in : $(curl -s $NIXOS_CHANNELS | sed -n '/folder/ { s,.*href=",,; s,/".*,,; p }'); do
    test "$channelName" = : && continue;

    # Do not follow redirections, such that we can extract the
    # short-changeset from the name of the directory where we are
    # redirected to.
    sha1=$(curl -s --max-redirs 0 $NIXOS_CHANNELS$channelName | sed -n '/has moved/ { s,.*\.\([a-z0-9A-Z]*\)".*,\1,; p; }')
    test -z "$sha1" -o -z "$channelName" && continue;

    # Update the local channels/* branches to be in-sync with the
    # channel references.
    git update-ref refs/heads/channels/$channelName $sha1
done
