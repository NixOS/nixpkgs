{ lib }:

/*
  List of upgrade groups.

   ```nix
   handle = {
     # Required
     prTitle = oldPkgs: newPkgs: "PR title that nixpkgs-update will use";

     # Optional
     meta = {
       maintainers = with lib.maintainers; [ ];
       teams = with lib.teams; [ ];
     };
   };
   ```

   where

   - `handle` is the handle you are going to use in nixpkgs expressions,
   - `prTitle` is the PR title nixpkgs-update will use when opening update PRs
   - `meta.maintainers` / `meta.teams` correspond to the maintainers/teams that are responsible for the package group

   When editing this file:
    * keep the list alphabetically sorted
    * the commit convention for this file are as follows:
      * `maintainers/upgradeGroups/<handle>: init` for adding a new upgrade group
      * `maintainers/upgradeGroups/<handle>: drop` for removing an upgrade group
      * `maintainers/upgradeGroups/<handle>: <...>` for any changes associated with a particular upgrade group
      * `maintainers/upgradeGroups: <...>` for miscellaneous file-wide changes
*/
lib.mapAttrs (name: value: value // { inherit name; }) {
  # keep-sorted start case=no numeric=no block=yes
  # keep-sorted end
}
