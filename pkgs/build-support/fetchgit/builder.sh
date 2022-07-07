# tested so far with:
# - no revision specified and remote has a HEAD which is used
# - revision specified and remote has a HEAD
# - revision specified and remote without HEAD
source $stdenv/setup

header "exporting $url (rev $rev) into $out"

$SHELL $fetcher --builder --url "$url" --out "$out" --rev "$rev" \
  ${leaveDotGit:+--leave-dotGit} \
  ${fetchLFS:+--fetch-lfs} \
  ${deepClone:+--deepClone} \
  ${fetchSubmodules:+--fetch-submodules} \
  ${sparseCheckout:+--sparse-checkout "$sparseCheckout"} \
  ${branchName:+--branch-name "$branchName"}

runHook postFetch
stopNest
