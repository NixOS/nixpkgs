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

        % nix-shell maintainers/scripts/coverage.nix --argstr maintainer garbas

    to run all update scripts for all packages that lists \`garbas\` as a maintainer
    and have \`updateScript\` defined, or:

        % nix-shell maintainers/scripts/coverage.nix --argstr package nautilus

    to run update script for specific package, or

        % nix-shell maintainers/scripts/coverage.nix --arg predicate '(path: pkg: pkg.updateScript.name or null == "gnome-update-script")'

    to run update script for all packages matching given predicate, or

        % nix-shell maintainers/scripts/coverage.nix --argstr path gnome

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
      inherit (lib) optionalAttrs;
    in
    lib.filterAttrsRecursive (_: v: v != { }) {
      package = attrPath;
      name = package.name;
      pname = lib.getName package;
      version = lib.getVersion package;
      outputs = package.outputs;

      attributes = {
        src =
          { }
          # https://github.com/NixOS/nixpkgs/issues/325892
          # checking if outputHashAlgo != null may be better here? basically the same thing tho
          // optionalAttrs (package ? src.hash) { srihash = !(lib.hasInfix ":" package.src.hash); }

          # currently fetchFromSourcehut doesn't support tag which breaks eval here
          // optionalAttrs (package ? src.gitRepoUrl) { tag = package.src.tag != null; };

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
          usesRunHooks =
            { }
            // optionalAttrs (package ? unpackPhase) {
              unpackPhase = checkPhaseHooks "preUnpack" "postUnpack" package.unpackPhase;
            }
            // optionalAttrs (package ? patchPhase) {
              patchPhase = checkPhaseHooks "prePatch" "postPatch" package.patchPhase;
            }
            // optionalAttrs (package ? configurePhase) {
              configurePhase = checkPhaseHooks "preConfigure" "postConfigure" package.configurePhase;
            }
            // optionalAttrs (package ? buildPhase) {
              buildPhase = checkPhaseHooks "preBuild" "postBuild" package.buildPhase;
            }
            // optionalAttrs (package ? installPhase) {
              installPhase = checkPhaseHooks "preInstall" "postInstall" package.installPhase;
            }
            // optionalAttrs (package ? checkPhase) {
              checkPhase = checkPhaseHooks "preCheck" "postCheck" package.checkPhase;
            }
            // optionalAttrs (package ? installCheckPhase) {
              installCheckPhase = checkPhaseHooks "preInstallCheck" "postInstallCheck" package.installCheckPhase;
            }
            // optionalAttrs (package ? fixupPhase) {
              fixupPhase = checkPhaseHooks "preFixup" "postFixup" package.fixupPhase;
            };
        };

        stdenv =
          { }
          # https://github.com/NixOS/nixpkgs/issues/79303
          // optionalAttrs (package ? env.NIX_CFLAGS_COMPILE || package ? NIX_CFLAGS_COMPILE) {
            NIX_CFLAGS_COMPILE = true;
          };

        python =
          { }
          # https://github.com/NixOS/nixpkgs/issues/515974
          # https://github.com/NixOS/nixpkgs/issues/253154
          // optionalAttrs (package ? pyproject) { pyproject = package.pyproject != false; }
          # checks pyproject because its in all python builders
          // optionalAttrs (package ? pyproject) { pythonImportsCheck = package ? pythonImportsCheck; };

        node =
          { }
          # https://github.com/NixOS/nixpkgs/issues/529285
          // optionalAttrs (package ? pnpmDeps.pnpm.version) { pnpm = package.pnpmDeps.pnpm.version; }
          // optionalAttrs (package ? pnpmDeps) { pnpmfetcher = package.pnpmDeps.fetcherVersion; }
          # kinda hacky but seems mostly consistent across the repo?.. tested on mdx-language-server
          // optionalAttrs (
            package ? postPatch
            && builtins.typeOf package.postPatch == "string"
            && lib.hasInfix "package-lock.json" package.postPatch
          ) { lockFile = true; };

        rust =
          { }
          # https://github.com/NixOS/nixpkgs/issues/327064
          // optionalAttrs (package ? cargoDeps.lockFile) { lockFile = true; };

        go = { } // optionalAttrs (package ? ldflags) { ldflags = package.ldflags; };
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
