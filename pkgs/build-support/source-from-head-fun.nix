/*
   purpose: mantain bleeding edge head sources.

   you run
   app --update
   app --publish
   to create source snapshots

   The documentation is availible at http://github.com/MarcWeber/nix-repository-manager/raw/master/README

*/
{ getConfig }:
  localTarName: publishedSrcSnapshot:
  if getConfig ["sourceFromHead" "useLocalRepos"] false then
    "${getConfig ["sourceFromHead" "managedRepoDir"] "/set/sourceFromHead.managedRepoDir/please"}/dist/${localTarName}"
  else publishedSrcSnapshot
