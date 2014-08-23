# tested so far with:
# - no revision specified and remote has a HEAD which is used
# - revision specified and remote has a HEAD
# - revision specified and remote without HEAD
source $stdenv/setup

header "exporting $url (rev $rev) into $out"

$fetcher --builder --url "$url" --out "$out" --rev "$rev" \
  ${leaveDotGit:+--leave-dotGit} \
  ${fetchSubmodules:+--fetch-submodules}

stopNest
