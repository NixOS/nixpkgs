let
  githubTeams = builtins.fromJSON (builtins.readFile ./github-teams.json);
in
{ lib }:
let
  teams = import ./team-list.nix { inherit lib; };
  maintainersById = lib.mapAttrs (name: values: lib.head values) (
    lib.groupBy (attrs: toString attrs.githubId) (
      lib.mapAttrsToList (name: attrs: attrs) lib.maintainers
    )
  );
in
lib.mapAttrs (
  name: attrs:
  if attrs ? github && attrs.syncGitHub or true then
    let
      githubTeam = githubTeams.${attrs.github};
    in
    assert lib.assertMsg (!attrs ? shortName)
      "lib.teams.${name}: Both `shortName` and `github` is set, but the former is synced from the latter";
    assert lib.assertMsg (
      !attrs ? scope
    ) "lib.teams.${name}: Both `scope` and `github` is set, but the former is synced from the latter";
    assert lib.assertMsg (
      !attrs ? members
    ) "lib.teams.${name}: Both `members` and `github` is set, but the former is synced from the latter";
    attrs
    // {
      shortName = githubTeam.name;
      scope = githubTeam.description;
      githubMaintainers = lib.mapAttrsToList (
        login: id:
        maintainersById.${toString id}
        or (lib.warn "lib.teams: No maintainer entry for GitHub user @${login} who's part of the @NixOS/${attrs.github} team" null)
      ) githubTeam.maintainers;
      members = lib.mapAttrsToList (
        login: id:
        maintainersById.${toString id}
        or (lib.warn "lib.teams: No maintainer entry for GitHub user @${login} who's part of the @NixOS/${attrs.github} team" null)
      ) githubTeam.members;
    }
  else
    attrs
) teams
