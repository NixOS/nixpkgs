{ package ? null
, maintainer ? null
, path ? null
}:

# TODO: add assert statements

let

  pkgs = import ./../../default.nix { };

  packagesWith = cond: return: set:
    pkgs.lib.unique
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
          builtins.throw "Maintainer with name `${maintainer'} does not exist in `lib/maintainers.nix`."
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
        builtins.throw "Package with an attribute name `${name}` does have an `passthru.updateScript` defined."
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
  '';

  runUpdateScript = package: ''
    echo -ne " - ${package.name}: UPDATING ..."\\r
    ${package.updateScript} &> ${(builtins.parseDrvName package.name).name}.log
    CODE=$?
    if [ "$CODE" != "0" ]; then
      echo " - ${package.name}: ERROR       "
      echo ""
      echo "--- SHOWING ERROR LOG FOR ${package.name} ----------------------"
      echo ""
      cat ${(builtins.parseDrvName package.name).name}.log
      echo ""
      echo "--- SHOWING ERROR LOG FOR ${package.name} ----------------------"
      exit $CODE
    else
      rm ${(builtins.parseDrvName package.name).name}.log
    fi
    echo " - ${package.name}: DONE.       "
  '';

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
    echo ""
    echo "Going to be running update for following packages:"
    echo "${builtins.concatStringsSep "\n" (map (x: " - ${x.name}") packages)}"
    echo ""
    read -n1 -r -p "Press space to continue..." confirm
    if [ "$confirm" = "" ]; then
      echo ""
      echo "Running update for:"
      ${builtins.concatStringsSep "\n" (map runUpdateScript packages)}
      echo ""
      echo "Packages updated!"
      exit 0
    else
      echo "Aborting!"
      exit 1
    fi
  '';
}
