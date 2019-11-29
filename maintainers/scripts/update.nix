{ package ? null
, maintainer ? null
, path ? null
, max-workers ? null
, keep-going ? null
}:

# TODO: add assert statements

let
  /* Remove duplicate elements from the list based on some extracted value. O(n^2) complexity.
   */
  nubOn = f: list:
    if list == [] then
      []
    else
      let
        x = pkgs.lib.head list;
        xs = pkgs.lib.filter (p: f x != f p) (pkgs.lib.drop 1 list);
      in
        [x] ++ nubOn f xs;

  pkgs = import ./../../default.nix {
    overlays = [];
  };

  packagesWith = cond: return: set:
    nubOn (pkg: pkg.updateScript)
      (pkgs.lib.flatten
        (pkgs.lib.mapAttrsToList
          (name: pkg:
            let
              result = builtins.tryEval (
                if pkgs.lib.isDerivation pkg && cond name pkg
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
        if ! builtins.hasAttr maintainer' pkgs.lib.maintainers then
          builtins.throw "Maintainer with name `${maintainer'} does not exist in `maintainers/maintainer-list.nix`."
        else
          builtins.getAttr maintainer' pkgs.lib.maintainers;
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
      attrSet = pkgs.lib.attrByPath (pkgs.lib.splitString "." path) null pkgs;
    in
      if attrSet == null then
        builtins.throw "Attribute path `${path}` does not exists."
      else
        packagesWith (name: pkg: builtins.hasAttr "updateScript" pkg)
                       (name: pkg: pkg)
                       attrSet;

  packageByName = name:
    let
        package = pkgs.lib.attrByPath (pkgs.lib.splitString "." name) null pkgs;
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

        % nix-shell maintainers/scripts/update.nix --argstr package garbas

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
    pname = pkgs.lib.getName package;
    updateScript = map builtins.toString (pkgs.lib.toList package.updateScript);
  };

  packagesJson = pkgs.writeText "packages.json" (builtins.toJSON (map packageData packages));

  optionalArgs =
    pkgs.lib.optional (max-workers != null) "--max-workers=${max-workers}"
    ++ pkgs.lib.optional (keep-going == "true") "--keep-going";

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
