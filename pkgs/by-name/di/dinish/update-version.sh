#!/bin/sh
# Update the fontinfo.plist for all fonts:
#   Version major/minor is set to the version from the git tag, e.g. v2.006
#
#   openTypeNameVersion is set to Version: tag; git-hash-release
#   (e.g., Version: v2.006; git-1a2b3c4d-release) for releases built from
#   the git tag, or to Version: tag; git-hash+revs-mods-dev for dev
#   builds, e.g., Version 2.006; git-3ccbb4c+36-13-dev .
#   The +36 indicates that this build is 36 commits ahead of 2.006.
#   The -13 indicates that there are uncommitted changes to 13
#   files, and that the build is not reproducable.
#
#   openTypeHeadCreated is set to the build date and time.

major="@major@"
minor="@minor@"
hash="@hash@"
status="release"

version=$(printf "%d.%03d" $major $minor)
versionstr="Version $version; git-$hash-$status"
now=$(date -u -d "@$SOURCE_DATE_EPOCH" +'%Y/%m/%d %H:%M:%S')

for ufo in sources/DINish*/DINish*.ufo; do
  sed -i \
    -e "\|versionMajor|,+1s|>[0-9]*<|>$major<|" \
    -e "\|versionMinor|,+1s|>[0-9]*<|>$minor<|" \
    -e "\|openTypeHeadCreated|,+1s|>[0-9].*<|>$now<|" \
    -e "\|openTypeNameVersion|,+1s|>Version [^<]*<|>$versionstr<|" \
    "$ufo/fontinfo.plist"
done
