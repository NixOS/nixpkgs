{
  stdenvNoCC,
  writeTextFile,
  gnutar,
  lib,
}:
let
  # deno uses a subset of the json file available at `https://registry.npmjs.org/<packageName>` and calls it registry.json
  # here we construct a registry.json file from the information we have. we only use the bare minimum of necessary keys and values.
  makeRegistryJsonContent = parsedPackageSpecifier: {
    name = parsedPackageSpecifier.name;
    dist-tags = { };
    "_deno.etag" = "";
    versions."${parsedPackageSpecifier.version}" = {
      version = parsedPackageSpecifier.version;
      dist = {
        tarball = "";
      };
      bin = { };
    };
  };

  makeRegistryJsonPath =
    root: parsedPackageSpecifier:
    let
      withScope = "${root}/@${parsedPackageSpecifier.scope}/${parsedPackageSpecifier.name}/registry.json";
      withoutScope = "${root}/${parsedPackageSpecifier.name}/registry.json";
    in
    if parsedPackageSpecifier.scope != null then withScope else withoutScope;

  makeRegistryJsonCommand = path: content: ''
    mkdir -p $(dirname "${path}");
    echo -n '${content}' > "${path}";
  '';

  makeRegistryJsonCommands =
    root: allFiles:
    let
      map =
        builtins.foldl'
          (
            acc: elem:
            let
              path = builtins.head (builtins.attrNames elem);
            in
            if builtins.hasAttr path acc then
              acc
              // {
                "${path}" = acc."${path}" // {
                  versions = elem."${path}".versions // acc."${path}".versions;
                };
              }
            else
              acc // elem
          )
          { }
          (
            builtins.map (
              file:
              let
                parsedPackageSpecifier = file.meta.parsedPackageSpecifier;
                content = makeRegistryJsonContent parsedPackageSpecifier;
                path = makeRegistryJsonPath root parsedPackageSpecifier;
              in
              {
                "${path}" = content;
              }
            ) allFiles
          );
    in
    builtins.concatStringsSep "\n" (
      builtins.attrValues (
        builtins.mapAttrs (path: content: makeRegistryJsonCommand path content) (
          builtins.mapAttrs (name: builtins.toJSON) map
        )
      )
    );

  makePackagePath =
    root: parsedPackageSpecifier:
    let
      withScope = "${root}/@${parsedPackageSpecifier.scope}/${parsedPackageSpecifier.name}/${parsedPackageSpecifier.version}";
      withoutScope = "${root}/${parsedPackageSpecifier.name}/${parsedPackageSpecifier.version}";
    in
    if parsedPackageSpecifier.scope != null then withScope else withoutScope;

  makePackageCommand =
    root: file:
    let
      outPath = makePackagePath root file.meta.parsedPackageSpecifier;
    in
    ''
      mkdir -p ${outPath};
      tar -C ${outPath} -xzf ${file.outPath} --strip-components=1;
    '';

  makePackageCommands =
    root: allFiles: builtins.concatStringsSep "\n" (builtins.map (makePackageCommand root) allFiles);

  transformNpmPackages =
    {
      name,
      allFiles,
      denoDir,
    }:
    let
      root = "$out/${denoDir}/npm/registry.npmjs.org";
      cpCommands = makePackageCommands root allFiles;
      registryJsonCommands = makeRegistryJsonCommands root allFiles;
    in
    stdenvNoCC.mkDerivation {
      name = "${name}-npm";

      src = null;
      unpackPhase = "true";

      buildPhase = '''' + cpCommands
      + registryJsonCommands;
      dontFixup = true;

      nativeBuildInputs = [
        gnutar
      ];
    };

in
{
  inherit transformNpmPackages;
}
