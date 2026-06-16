/*
  To run:

      nix-shell maintainers/scripts/coverage.nix

  See the issues labeled as 'tracking' for more ideas
*/
{
  package ? null,
  maintainer ? null,
  team ? null,
  predicate ? null,
  get-script ? pkg: pkg.updateScript or null,
  path ? null,
  max-workers ? null,
  include-overlays ? false,
  order ? null,
}:

let
  pkgs = import ./../../default.nix (
    (
      if include-overlays == false then
        { overlays = [ ]; }
      else if include-overlays == true then
        { } # Let Nixpkgs include overlays impurely.
      else
        { overlays = include-overlays; }
    )
    // {
      config.allowAliases = false;
      # allow maintainers to run this script on multiple platforms
      config.allowUnsupportedSystem = true;
      config.allowUnfree = true;
    }
  );

  inherit (pkgs) lib;

  # Remove duplicate elements from the list based on some extracted value. O(n^2) complexity.
  nubOn =
    f: list:
    if list == [ ] then
      [ ]
    else
      let
        x = lib.head list;
        xs = lib.filter (p: f x != f p) (lib.drop 1 list);
      in
      [ x ] ++ nubOn f xs;

  /*
    Recursively find all packages (derivations) in `pkgs` matching `cond` predicate.

    Type: packagesWithPath :: AttrPath → (AttrPath → derivation → bool) → AttrSet → List<AttrSet{attrPath :: str; package :: derivation; }>
          AttrPath :: [str]

    The packages will be returned as a list of named pairs comprising of:
      - attrPath: stringified attribute path (based on `rootPath`)
      - package: corresponding derivation
  */
  packagesWithPath =
    rootPath: cond: pkgs:
    let
      packagesWithPathInner =
        path: pathContent:
        let
          result = builtins.tryEval pathContent;

          somewhatUniqueRepresentant =
            { package, attrPath }:
            {
              updateScript = (get-script package);
              # Some updaters use the same `updateScript` value for all packages.
              # Also compare `meta.description`.
              position = package.meta.position or null;
              # We cannot always use `meta.position` since it might not be available
              # or it might be shared among multiple packages.
            };

          dedupResults = lst: nubOn somewhatUniqueRepresentant (lib.concatLists lst);
        in
        if result.success then
          let
            evaluatedPathContent = result.value;
          in
          if lib.isDerivation evaluatedPathContent then
            lib.optional (cond path evaluatedPathContent) {
              attrPath = lib.concatStringsSep "." path;
              package = evaluatedPathContent;
            }
          else if lib.isAttrs evaluatedPathContent then
            # If user explicitly points to an attrSet or it is marked for recursion, we recur.
            if
              path == rootPath
              || evaluatedPathContent.recurseForDerivations or false
              || evaluatedPathContent.recurseForRelease or false
            then
              dedupResults (
                lib.mapAttrsToList (name: elem: packagesWithPathInner (path ++ [ name ]) elem) evaluatedPathContent
              )
            else
              [ ]
          else
            [ ]
        else
          [ ];
    in
    packagesWithPathInner rootPath pkgs;

  # Recursively find all packages (derivations) in `pkgs` matching `cond` predicate.
  packagesWith = packagesWithPath [ ];

  # Recursively find all packages in `pkgs` with updateScript matching given predicate.
  packagesWithUpdateScriptMatchingPredicate =
    cond: packagesWith (path: pkg: (get-script pkg != null) && cond path pkg);

  # Recursively find all packages in `pkgs` with updateScript by given maintainer.
  packagesWithUpdateScriptAndMaintainer =
    maintainer':
    let
      maintainer =
        if !builtins.hasAttr maintainer' lib.maintainers then
          throw "Maintainer with name `${maintainer'} does not exist in `maintainers/maintainer-list.nix`."
        else
          builtins.getAttr maintainer' lib.maintainers;
    in
    packagesWithUpdateScriptMatchingPredicate (
      path: pkg:
      (
        if builtins.hasAttr "maintainers" pkg.meta then
          (
            if builtins.isList pkg.meta.maintainers then
              builtins.elem maintainer pkg.meta.maintainers
            else
              maintainer == pkg.meta.maintainers
          )
        else
          false
      )
    );

  # Recursively find all packages in `pkgs` with updateScript by given team.
  packagesWithUpdateScriptAndTeam =
    team':
    let
      team =
        if !builtins.hasAttr team' lib.teams then
          throw "Team with name `${team'} does not exist in `maintainers/team-list.nix`."
        else
          builtins.getAttr team' lib.teams;
    in
    packagesWithUpdateScriptMatchingPredicate (
      path: pkg:
      (
        if builtins.hasAttr "teams" pkg.meta then
          (
            if builtins.isList pkg.meta.teams then builtins.elem team pkg.meta.teams else team == pkg.meta.teams
          )
        else
          false
      )
    );

  # Recursively find all packages under `path` in `pkgs` with updateScript.
  packagesWithUpdateScript =
    path: pkgs:
    let
      prefix = lib.splitString "." path;
      pathContent = lib.attrByPath prefix null pkgs;
    in
    if pathContent == null then
      throw "Attribute path `${path}` does not exist."
    else
      packagesWithPath prefix (path: pkg: (get-script pkg != null)) pathContent;

  # Find a package under `path` in `pkgs` and require that it has an updateScript.
  packageByName =
    path: pkgs:
    let
      package = lib.attrByPath (lib.splitString "." path) null pkgs;
    in
    if package == null then
      throw "Package with an attribute name `${path}` does not exist."
    else
      {
        attrPath = path;
        inherit package;
      };

  # List of packages matched based on the CLI arguments.
  packages =
    if package != null then
      [ (packageByName package pkgs) ]
    else if predicate != null then
      packagesWithUpdateScriptMatchingPredicate predicate pkgs
    else if maintainer != null then
      packagesWithUpdateScriptAndMaintainer maintainer pkgs
    else if team != null then
      packagesWithUpdateScriptAndTeam team pkgs
    else if path != null then
      packagesWithUpdateScript path pkgs
    else
      throw "No arguments provided.\n\n${helpText}";

  helpText = ''
    Please run:

        % nix-shell maintainers/scripts/update.nix --argstr maintainer garbas

    to run all update scripts for all packages that lists \`garbas\` as a maintainer
    and have \`updateScript\` defined, or:

        % nix-shell maintainers/scripts/update.nix --argstr package nautilus

    to run update script for specific package, or

        % nix-shell maintainers/scripts/update.nix --arg predicate '(path: pkg: pkg.updateScript.name or null == "gnome-update-script")'

    to run update script for all packages matching given predicate, or

        % nix-shell maintainers/scripts/update.nix --argstr path gnome

    to run update script for all package under an attribute path.

    You can also add

        --argstr max-workers 8

    By default, the updater will update the packages in arbitrary order. Alternately, you can force a specific order based on the packages’ dependency relations:

        - Reverse topological order (e.g. {"gnome-text-editor", "gimp"}, {"gtk3", "gtk4"}, {"glib"}) is useful when you want checkout each commit one by one to build each package individually but some of the packages to be updated would cause a mass rebuild for the others. Of course, this requires that none of the updated dependents require a new version of the dependency.

            --argstr order reverse-topological

        - Topological order (e.g. {"glib"}, {"gtk3", "gtk4"}, {"gnome-text-editor", "gimp"}) is useful when the updated dependents require a new version of updated dependency.

            --argstr order topological

    Note that sorting requires instantiating each package and then querying Nix store for requisites so it will be pretty slow with large number of packages.
  '';

  checkPhaseHooks =
    pre: post: package:
    package != null && lib.hasInfix "runHook ${pre}" package && lib.hasInfix "runHook ${post}" package;

  # Transform a matched package into an object for update.py.
  packageData =
    { package, attrPath }:
    let
      updateScript = get-script package;
    in
    {
      name = package.name;
      pname = lib.getName package;
      version = lib.getVersion package;
      outputs = package.outputs;

      # see https://github.com/NixOS/nixpkgs/pull/506793
      # premature optimization can be fun :)
      # ${ if ? then } syntax over // optionalAttrs for perf benefits
      attributes = {
        src = {
          # currently fetchFromSourcehut doesn't support tag which breaks eval here
          # ${if package ? src.gitRepoUrl then "tag" else null} = package.src.tag != null;

          # https://github.com/NixOS/nixpkgs/issues/325892
          ${if package ? src.hash then "srihash" else null} = !(lib.hasInfix ":" package.src.hash);
        };

        common = {
          # https://github.com/NixOS/nixpkgs/issues/178468
          strictDeps = package.strictDeps;
          # https://github.com/NixOS/nixpkgs/issues/205690
          __structuredAttrs = package.__structuredAttrs;

          # https://github.com/NixOS/nixpkgs/issues/205690#issuecomment-4710988930
          parallel = {
            enableParallelBuilding = package ? enableParallelBuilding && package.enableParallelBuilding;
            enableParallelChecking = package ? enableParallelChecking && package.enableParallelChecking;
            enableParallelInstalling = package ? enableParallelInstalling && package.enableParallelInstalling;
          };

          # list found from `rg runHook (pre|post)` and stdenv.chapter.md
          # not comprehensive by any means, but these are the most common
          usesRunHooks = {
            ${if package ? unpackPhase then "unpackPhase" else null} =
              checkPhaseHooks "preUnpack" "postUnpack"
                package.unpackPhase;

            ${if package ? patchPhase then "patchPhase" else null} =
              checkPhaseHooks "prePatch" "postPatch"
                package.patchPhase;

            ${if package ? configurePhase then "configurePhase" else null} =
              checkPhaseHooks "preConfigure" "postConfigure"
                package.configurePhase;

            ${if package ? buildPhase then "buildPhase" else null} =
              checkPhaseHooks "preBuild" "postBuild"
                package.buildPhase;

            ${if package ? installPhase then "installPhase" else null} =
              checkPhaseHooks "preInstall" "postInstal"
                package.installPhase;

            ${if package ? checkPhase then "checkPhase" else null} =
              checkPhaseHooks "preCheck" "postCheck"
                package.checkPhase;

            ${if package ? installCheckPhase then "installCheckPhase" else null} =
              checkPhaseHooks "preInstallCheck" "postInstallCheck"
                package.installCheckPhase;

            ${if package ? fixupPhase then "fixupPhase" else null} =
              checkPhaseHooks "preFixup" "postFixup"
                package.fixupPhase;
          };
        };

        # https://github.com/NixOS/nixpkgs/issues/79303
        stdenv = {
          NIX_CFLAGS_COMPILE = package ? env.NIX_CFLAGS_COMPILE || package ? NIX_CFLAGS_COMPILE;
        };

        python = {
          # https://github.com/NixOS/nixpkgs/issues/515974
          # https://github.com/NixOS/nixpkgs/issues/253154
          ${if package ? pyproject then "pyproject" else null} =
            package.pyproject != null && package.pyproject != false;

          # checks pyproject because its in all python builders
          ${if package ? pyproject then "pythonImportsCheck" else null} = package ? pythonImportsCheck;
        };

        node = {
          # https://github.com/NixOS/nixpkgs/issues/529285
          ${if package ? pnpmDeps.pnpm.version then "pnpm" else null} = package.pnpmDeps.pnpm.version;

          ${if package ? pnpmDeps then "pnpmfetcher" else null} = package.pnpmDeps.fetcherVersion;
          # kinda hacky but seems mostly consistent across the repo?.. tested on mdx-language-server
          ${
            if
              package ? postPatch
              && builtins.typeOf package.postPatch == "string"
              && lib.hasInfix "package-lock.json" package.postPatch
            then
              "lockFile"
            else
              null
          } =
            true;
        };

        rust = {
          # https://github.com/NixOS/nixpkgs/issues/327064
          ${if package ? cargoDeps && package.cargoDeps ? lockFile then "lockFile" else null} = true; # want to get rid of these
        };

        go = {
          ${if package ? ldflags then "ldflags" else null} = package.ldflags;
        };
      };

    };

  # JSON file with data for update.py.
  packagesJson = pkgs.writeText "packages.json" (builtins.toJSON (map packageData packages));
in
pkgs.stdenvNoCC.mkDerivation {
  name = "nixpkgs-coverage-checker";
  buildCommand = ''
    echo ""
    echo "----------------------------------------------------------------"
    echo ""
    echo "Not possible to observe coverage using \`nix-build\`"
    echo ""
    echo "${helpText}"
    echo "----------------------------------------------------------------"
    exit 1
  '';
  shellHook = ''
    unset shellHook # do not contaminate nested shells
    exec ${lib.getExe' pkgs.toybox "cat"} ${packagesJson} | ${lib.getExe pkgs.jq}
    exit 0 # prevent new shell
  '';
}
