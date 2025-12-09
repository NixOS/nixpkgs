# tested so far with:
# - no revision specified and remote has a HEAD which is used
# - revision specified and remote has a HEAD
# - revision specified and remote without HEAD
#

echo "exporting $url (rev $rev) into $out"

runHook preFetch

if [ -n "$gitConfigFile" ]; then
  echo "using GIT_CONFIG_GLOBAL=$gitConfigFile"
  export GIT_CONFIG_GLOBAL="$gitConfigFile"
fi

$SHELL $fetcher --builder --url "$url" --out "$out" --rev "$rev" --name "$name" \
  ${leaveDotGit:+--leave-dotGit} \
  ${fetchLFS:+--fetch-lfs} \
  ${deepClone:+--deepClone} \
  ${fetchSubmodules:+--fetch-submodules} \
  ${fetchTags:+--fetch-tags} \
  ${sparseCheckoutText:+--sparse-checkout "$sparseCheckoutText"} \
  ${nonConeMode:+--non-cone-mode} \
  ${branchName:+--branch-name "$branchName"} \
  ${rootDir:+--root-dir "$rootDir"}

runHook postFetch
