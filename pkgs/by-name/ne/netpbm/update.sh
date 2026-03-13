#!/usr/bin/env nix-shell
#!nix-shell -p bash -p subversion -p common-updater-scripts -i bash

die() {
    echo "error: $1" >&2
    exit 1
}

attr=netpbm
svnRoot=https://svn.code.sf.net/p/netpbm/code/advanced

oldRev=$(nix-instantiate --eval -E "with import ./. {}; $attr.src.rev" | tr -d '"')
if [[ -z "$oldRev" ]]; then
    die "Could not extract old revision."
fi

latestRev=$(svn info --show-item "last-changed-revision" "$svnRoot")
if [[ -z "$latestRev" ]]; then
    die "Could not find out last changed revision."
fi

versionInfo=$(svn cat -r "$latestRev" "$svnRoot/version.mk")
if [[ -z "$versionInfo" ]]; then
    die "Could not get version info."
fi

nixFile=$(nix-instantiate --eval --strict -A "$attr.meta.position" | sed -re 's/^"(.*):[0-9]+"$/\1/')
if [[ ! -f "$nixFile" ]]; then
    die "Could not evaluate '$attr.meta.position' to locate the .nix file!"
fi

# h remembers if we found the pattern; on the last line, if a pattern was previously found, we exit with 1
# https://stackoverflow.com/a/12145797/160386
sed -i "$nixFile" -re '/(\brev\b\s*=\s*)"'"$oldRev"'"/{ s||\1"'"$latestRev"'"|; h }; ${x; /./{x; q1}; x}' && die "Unable to update revision."

majorRelease=$(grep --perl-regex --only-matching 'NETPBM_MAJOR_RELEASE = \K.+' <<< "$versionInfo")
minorRelease=$(grep --perl-regex --only-matching 'NETPBM_MINOR_RELEASE = \K.+' <<< "$versionInfo")
pointRelease=$(grep --perl-regex --only-matching 'NETPBM_POINT_RELEASE = \K.+' <<< "$versionInfo")

update-source-version "$attr" "$majorRelease.$minorRelease.$pointRelease"
