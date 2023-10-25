{ lib
, fetchurl
, fetchgit
, runCommand
}:

{
  # The source directory of the package.
  src

  # The package subdirectory within src.
  # Useful if the package references sibling packages with relative paths.
, packageRoot ? "."

  # The pubspec.lock file, in attribute set form.
, pubspecLock

  # Hashes for Git dependencies.
  # Pub does not record these itself, so they must be manually provided.
, gitHashes ? { }

  # Functions to generate SDK package sources.
  # The function names should match the SDK names, and the package name is given as an argument.
, sdkSourceBuilders ? { }
}:

let
  dependencyVersions = builtins.mapAttrs (name: details: details.version) pubspecLock.packages;

  dependencyTypes = {
    "direct main" = "main";
    "direct dev" = "dev";
    "direct overridden" = "overridden";
    "transitive" = "transitive";
  };

  dependencies = lib.foldlAttrs
    (dependencies: name: details: dependencies // { ${dependencyTypes.${details.dependency}} = dependencies.${dependencyTypes.${details.dependency}} ++ [ name ]; })
    (lib.genAttrs (builtins.attrValues dependencyTypes) (dependencyType: [ ]))
    pubspecLock.packages;

  mkHostedDependencySource = name: details:
    let
      archive = fetchurl {
        name = "pub-${name}-${details.version}.tar.gz";
        url = "${details.description.url}/packages/${details.description.name}/versions/${details.version}.tar.gz";
        sha256 = details.description.sha256;
      };
    in
    runCommand "pub-${name}-${details.version}"
      { } ''
      mkdir -p "$out"
      tar xf '${archive}' -C "$out"
    '';

  mkGitDependencySource = name: details: fetchgit {
    name = "pub-${name}-${details.version}";
    url = details.description.url;
    rev = details.description.resolved-ref;
    postFetch = ''
      if [ "$(realpath "$out/${details.description.path}")" != "$(realpath "$out")" ]; then
        (shopt -s dotglob; mv "$out"/* .)
        rmdir "$out"
        mv '${details.description.path}' "$out"
      fi
    '';
    hash = gitHashes.${name} or (throw "A Git hash is required for ${name}! Set to an empty string to obtain it.");
  };

  mkPathDependencySource = name: details:
    if builtins.isPath src
    then
    # When src is a path, avoid copying it to the store entirely, and allow
    # non-relative paths.
      (builtins.path {
        name = "pub-${name}-${details.version}";
        path = if details.description.relative then src + "/${packageRoot}" + "/${details.description.path}" else details.description.path;
      })
    else
      assert lib.assertMsg details.description.relative "Only relative paths are supported!";
      runCommand "pub-${name}-${details.version}" { } ''
        cp -r '${src}/${packageRoot}/${details.description.path}' "$out"
      '';

  mkSdkDependencySource = name: details:
    (sdkSourceBuilders.${details.description} or (throw "No SDK source builder has been given for ${details.description}!")) name;

  dependencySources = lib.filterAttrs (name: src: src != null) (builtins.mapAttrs
    (name: details: ({
      "hosted" = mkHostedDependencySource;
      "git" = mkGitDependencySource;
      "path" = mkPathDependencySource;
      "sdk" = mkSdkDependencySource;
    }.${details.source} name) details)
    pubspecLock.packages);
in
{
  inherit
    # An attribute set of dependency categories to package name lists.
    dependencies

    # An attribute set of package names to their versions.
    dependencyVersions

    # An attribute set of package names to their sources.
    dependencySources;
}
