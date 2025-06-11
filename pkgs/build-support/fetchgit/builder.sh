# tested so far with:
# - no revision specified and remote has a HEAD which is used
# - revision specified and remote has a HEAD
# - revision specified and remote without HEAD
#

echo "exporting $url (rev $rev) into $out"

runHook preFetch

$SHELL $fetcher --builder --url "$url" --out "$out" --rev "$rev" --name "$name" \
  ${leaveDotGit:+--leave-dotGit} \
  ${fetchLFS:+--fetch-lfs} \
  ${deepClone:+--deepClone} \
  ${fetchSubmodules:+--fetch-submodules} \
  ${fetchTags:+--fetch-tags} \
  ${sparseCheckout:+--sparse-checkout "$sparseCheckout"} \
  ${nonConeMode:+--non-cone-mode} \
  ${branchName:+--branch-name "$branchName"}

runHook postFetch
