# Extends ./team-list.nix with synced GitHub information from ./github-teams.json
{ lib }:
let
  githubTeams = lib.importJSON ./github-teams.json;
  teams = import ./team-list.nix { inherit lib; };

  # A fast maintainer id lookup table
  maintainersById = lib.pipe lib.maintainers [
    lib.attrValues
    (lib.groupBy (attrs: toString attrs.githubId))
    (lib.mapAttrs (_: lib.head))
  ];

  maintainerSetToList =
    githubTeam: users:
    let
      missingUsers = lib.filter (login: !maintainersById ? ${toString users.${login}}) (
        lib.attrNames users
      );
    in
    if missingUsers == [ ] then
      lib.mapAttrsToList (login: id: maintainersById.${toString id}) users
    else
      {
        errors = map (
          login:
          "\n- No maintainer entry for GitHub user @${login} who's part of the @NixOS/${githubTeam} team"
        ) missingUsers;
      };

  # TODO: Consider automatically exposing all GitHub teams under `lib.teams`,
  # so that no manual PRs are necessary to add such teams anymore
  result = lib.mapAttrs (
    name: attrs:
    if attrs ? github then
      let
        githubTeam =
          githubTeams.${attrs.github}
            or (throw "lib.teams.${name}: Corresponding GitHub team ${attrs.github} not known yet, make sure to create it and wait for the regular team sync");
        maintainers = maintainerSetToList attrs.github githubTeam.maintainers;
        nonMaintainers = maintainerSetToList attrs.github githubTeam.members;
      in
      # TODO: Consider specifying `githubId` in team-list.nix and inferring `github` from it (or even dropping it)
      # This would make renames easier because no additional place needs to keep track of them.
      # Though in a future where all Nixpkgs GitHub teams are automatically exposed under `lib.teams`,
      # this would also not be an issue anymore.
      assert lib.assertMsg (!attrs ? githubId)
        "lib.teams.${name}: Both `githubId` and `github` is set, but the former is synced from the latter";
      assert lib.assertMsg (!attrs ? shortName)
        "lib.teams.${name}: Both `shortName` and `github` is set, but the former is synced from the latter";
      assert lib.assertMsg (
        !attrs ? scope
      ) "lib.teams.${name}: Both `scope` and `github` is set, but the former is synced from the latter";
      assert lib.assertMsg (
        !attrs ? members
      ) "lib.teams.${name}: Both `members` and `github` is set, but the former is synced from the latter";
      if !maintainers ? errors && !nonMaintainers ? errors then
        attrs
        // {
          githubId = githubTeam.id;
          shortName = githubTeam.name;
          scope = githubTeam.description;
          members = maintainers ++ nonMaintainers;
          githubMaintainers = maintainers;
        }
      else
        maintainers.errors or [ ] ++ nonMaintainers.errors or [ ]
    else
      attrs
  ) teams;

  errors = lib.concatLists (
    lib.mapAttrsToList (name: value: value) (lib.filterAttrs (name: lib.isList) result)
  );
in
if errors == [ ] then result else throw ("lib.teams:" + lib.concatStrings errors)
