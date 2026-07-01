/*
   purpose: maintain bleeding edge head sources.

   you run
   app --update
   app --publish
   to create source snapshots

   The documentation is available at https://github.com/MarcWeber/nix-repository-manager/raw/master/README
*/
{ config }:
localTarName: publishedSrcSnapshot:
if config.sourceFromHead.useLocalRepos or false then
  "${
    config.sourceFromHead.managedRepoDir or "/set/sourceFromHead.managedRepoDir/please"
  }/dist/${localTarName}"
else
  publishedSrcSnapshot
