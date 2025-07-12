{
  lib,
  pkgs,
  fetchurl,
  callPackage,
}:
let
  inherit (callPackage ../lib.nix { }) mergePackagesList fixHash;

  makeMetaJsonUrl =
    parsedPackageSpecifier:
    "https://jsr.io/@${parsedPackageSpecifier.scope}/${parsedPackageSpecifier.name}/meta.json";

  makeVersionMetaJsonUrl =
    parsedPackageSpecifier:
    "https://jsr.io/@${parsedPackageSpecifier.scope}/${parsedPackageSpecifier.name}/${parsedPackageSpecifier.version}_meta.json";

  makeJsrPackageFileUrl =
    parsedPackageSpecifier: filePath:
    "https://jsr.io/@${parsedPackageSpecifier.scope}/${parsedPackageSpecifier.name}/${parsedPackageSpecifier.version}${filePath}";

  fetchVersionMetaJson =
    parsedPackageSpecifier: hash:
    fetchurl {
      url = makeVersionMetaJsonUrl parsedPackageSpecifier;
      hash = fixHash {
        inherit hash;
        algo = "sha256";
      };
    };

  makeVersionMetaJsonDerivation =
    parsedPackageSpecifier: hash: fetchVersionMetaJson parsedPackageSpecifier hash;

  makeMetaJsonDerivation =
    parsedPackageSpecifier:
    pkgs.writeTextFile {
      name = "meta.json";
      text = (
        builtins.toJSON {
          name = parsedPackageSpecifier.name;
          scope = parsedPackageSpecifier.scope;
          latest = parsedPackageSpecifier.version;
          versions."${parsedPackageSpecifier.version}" = { };
        }
      );
    };

  getFilesAndHashesUsingModuleGraph =
    parsedVersionMetaJson:
    let
      # instead of traversing the graph recursively, we just list the importers and the imported files and merge the lists
      moduleGraph =
        if parsedVersionMetaJson ? moduleGraph1 then
          parsedVersionMetaJson.moduleGraph1
        else if parsedVersionMetaJson ? moduleGraph2 then
          parsedVersionMetaJson.moduleGraph2
        else
          { };
      exported = builtins.map (path: lib.strings.removePrefix "." path) (
        builtins.attrValues parsedVersionMetaJson.exports
      );
      importers = builtins.attrNames moduleGraph;
      imported = lib.lists.flatten (
        builtins.attrValues (
          builtins.mapAttrs (
            name: value:
            let
              dependencies = if builtins.hasAttr "dependencies" value then value.dependencies else [ ];
              basePath = lib.path.subpath.join (
                lib.lists.dropEnd 1 (lib.path.subpath.components (lib.path.splitRoot (/. + name)).subpath)
              );
              hasSpecifier = dep: (dep.type == "static") && (builtins.hasAttr "specifier" dep);
              isPath = string: (builtins.match "^(\.\./|\./|/).*$" string) != null;
              getSpecifier = dep: if (hasSpecifier dep) && (isPath dep.specifier) then dep.specifier else null;
              resolvePath =
                dep:
                let
                  specifier = getSpecifier dep;
                in
                if specifier != null then builtins.toString (/. + "${basePath}/${specifier}") else null;
            in
            builtins.filter (value: value != null) (builtins.map (dep: resolvePath dep) dependencies)
          ) moduleGraph
        )
      );
      # using attrset keys to do a union operation over lists of strings
      union =
        let
          a = builtins.listToAttrs (
            builtins.map (v: {
              name = v;
              value = 0;
            }) importers
          );
          b = builtins.listToAttrs (
            builtins.map (v: {
              name = v;
              value = 0;
            }) imported
          );
          c = builtins.listToAttrs (
            builtins.map (v: {
              name = v;
              value = 0;
            }) exported
          );
        in
        a // b // c;
    in
    builtins.mapAttrs (fileName: value: parsedVersionMetaJson.manifest."${fileName}".checksum) union;

  makeJsrPackage =
    { parsedPackageSpecifier, hash }:
    let
      metaJsonDerivation = makeMetaJsonDerivation parsedPackageSpecifier;
      versionMetaJsonDerivation = makeVersionMetaJsonDerivation parsedPackageSpecifier hash;
      parsedVersionMetaJson = builtins.fromJSON (builtins.readFile versionMetaJsonDerivation);
      filesAndHashes = getFilesAndHashesUsingModuleGraph parsedVersionMetaJson;
      packageFiles = builtins.attrValues (
        builtins.mapAttrs (filePath: hash2: {
          hash = fixHash {
            hash = hash2;
            algo = "sha256";
          };
          url = makeJsrPackageFileUrl parsedPackageSpecifier filePath;
          meta = {
            fileName = "/${parsedPackageSpecifier.version}${filePath}";
            inherit parsedPackageSpecifier;
          };
        }) filesAndHashes
      );
    in
    {
      preFetched = {
        packagesFiles = [
          {
            outPath = "${metaJsonDerivation}";
            derivation = metaJsonDerivation;
            url = makeMetaJsonUrl parsedPackageSpecifier;
            meta = {
              fileName = "/meta.json";
              inherit parsedPackageSpecifier;
            };
          }
          {
            outPath = "${versionMetaJsonDerivation}";
            derivation = versionMetaJsonDerivation;
            url = makeVersionMetaJsonUrl parsedPackageSpecifier;
            meta = {
              fileName = "/${parsedPackageSpecifier.version}_meta.json";
              inherit parsedPackageSpecifier;
            };
          }
        ];
      };

      withHashPerFile = {
        packagesFiles = packageFiles;
      };
    };

  makeJsrPackages =
    { jsrParsed }:
    let
      jsrPackages = builtins.attrValues (builtins.mapAttrs (name: value: makeJsrPackage value) jsrParsed);
    in
    mergePackagesList jsrPackages;
in
{
  inherit makeJsrPackages;
}
