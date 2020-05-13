{ package ? null
, maintainer ? null
, path ? null
, max-workers ? null
, include-overlays ? false
, keep-going ? null
}:

# TODO: add assert statements

let
  pkgs = import ./../../default.nix (if include-overlays then { } else { overlays = []; });

  inherit (pkgs) lib;

  /* Remove duplicate elements from the list based on some extracted value. O(n^2) complexity.
   */
  nubOn = f: list:
    if list == [] then
      []
    else
      let
        x = lib.head list;
        xs = lib.filter (p: f x != f p) (lib.drop 1 list);
      in
        [x] ++ nubOn f xs;

  packagesWith = cond: return: set:
    nubOn (pkg: pkg.updateScript)
      (lib.flatten
        (lib.mapAttrsToList
          (name: pkg:
            let
              result = builtins.tryEval (
                if lib.isDerivation pkg && cond name pkg
                  then [(return name pkg)]
                else if pkg.recurseForDerivations or false || pkg.recurseForRelease or false
                  then packagesWith cond return pkg
                else []
              );
            in
              if result.success then result.value
              else []
          )
          set
        )
      );

  packagesWithUpdateScriptAndMaintainer = maintainer':
    let
      maintainer =
        if ! builtins.hasAttr maintainer' lib.maintainers then
          builtins.throw "Maintainer with name `${maintainer'} does not exist in `maintainers/maintainer-list.nix`."
        else
          builtins.getAttr maintainer' lib.maintainers;
    in
      packagesWith (name: pkg: builtins.hasAttr "updateScript" pkg &&
                                 (if builtins.hasAttr "maintainers" pkg.meta
                                   then (if builtins.isList pkg.meta.maintainers
                                           then builtins.elem maintainer pkg.meta.maintainers
                                           else maintainer == pkg.meta.maintainers
                                        )
                                   else false
                                 )
                   )
                   (name: pkg: pkg)
                   pkgs;

  packagesWithUpdateScript = path:
    let
      attrSet = lib.attrByPath (lib.splitString "." path) null pkgs;
    in
      if attrSet == null then
        builtins.throw "Attribute path `${path}` does not exists."
      else
        packagesWith (name: pkg: builtins.hasAttr "updateScript" pkg)
                       (name: pkg: pkg)
                       attrSet;

  packageByName = name:
    let
        package = lib.attrByPath (lib.splitString "." name) null pkgs;
    in
      if package == null then
        builtins.throw "Package with an attribute name `${name}` does not exists."
      else if ! builtins.hasAttr "updateScript" package then
        builtins.throw "Package with an attribute name `${name}` does not have a `passthru.updateScript` attribute defined."
      else
        package;

  packages =
    if package != null then
      [ (packageByName package) ]
    else if maintainer != null then
      packagesWithUpdateScriptAndMaintainer maintainer
    else if path != null then
      packagesWithUpdateScript path
    else
      builtins.throw "No arguments provided.\n\n${helpText}";

  helpText = ''
    Please run:

        % nix-shell maintainers/scripts/update.nix --argstr maintainer garbas

    to run all update scripts for all packages that lists \`garbas\` as a maintainer
    and have \`updateScript\` defined, or:

        % nix-shell maintainers/scripts/update.nix --argstr package gnome3.nautilus

    to run update script for specific package, or

        % nix-shell maintainers/scripts/update.nix --argstr path gnome3

    to run update script for all package under an attribute path.

    You can also add

        --argstr max-workers 8

    to increase the number of jobs in parallel, or

        --argstr keep-going true

    to continue running when a single update fails.
  '';

  packageData = package: {
    name = package.name;
    pname = lib.getName package;
    updateScript = map builtins.toString (lib.toList package.updateScript);
  };

  packagesJson = pkgs.writeText "packages.json" (builtins.toJSON (map packageData packages));

  optionalArgs =
    lib.optional (max-workers != null) "--max-workers=${max-workers}"
    ++ lib.optional (keep-going == "true") "--keep-going";

  args = [ packagesJson ] ++ optionalArgs;

in pkgs.stdenv.mkDerivation {
  name = "nixpkgs-update-script";
  buildCommand = ''
    echo ""
    echo "----------------------------------------------------------------"
    echo ""
    echo "Not possible to update packages using \`nix-build\`"
    echo ""
    echo "${helpText}"
    echo "----------------------------------------------------------------"
    exit 1
  '';
  shellHook = ''
    unset shellHook # do not contaminate nested shells
    exec ${pkgs.python3.interpreter} ${./update.py} ${builtins.concatStringsSep " " args}
  '';
}
