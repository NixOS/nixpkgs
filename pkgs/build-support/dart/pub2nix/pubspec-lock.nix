{
  lib,
  callPackage,
  fetchurl,
  fetchgit,
  runCommand,
}:

{
  # The source directory of the package.
  src,

  # The package subdirectory within src.
  # Useful if the package references sibling packages with relative paths.
  packageRoot ? ".",

  # The pubspec.lock file, in attribute set form.
  pubspecLock,

  # Hashes for Git dependencies.
  # Pub does not record these itself, so they must be manually provided.
  gitHashes ? { },

  # Functions to generate SDK package sources.
  # The function names should match the SDK names, and the package name is given as an argument.
  sdkSourceBuilders ? { },

  # Functions that create custom package source derivations.
  #
  # The function names should match the package names, and the package version,
  # source, and source files are given in an attribute set argument.
  #
  # The passthru of the source derivation should be propagated.
  customSourceBuilders ? { },
}:

let
  dependencyVersions = builtins.mapAttrs (name: details: details.version) pubspecLock.packages;

  dependencyTypes = {
    "direct main" = "main";
    "direct dev" = "dev";
    "direct overridden" = "overridden";
    "transitive" = "transitive";
  };

  dependencies = lib.foldlAttrs (
    dependencies: name: details:
    dependencies
    // {
      ${dependencyTypes.${details.dependency}} =
        dependencies.${dependencyTypes.${details.dependency}}
        ++ [ name ];
    }
  ) (lib.genAttrs (builtins.attrValues dependencyTypes) (dependencyType: [ ])) pubspecLock.packages;

  # fetchTarball fails with "tarball contains an unexpected number of top-level files". This is a workaround.
  # https://discourse.nixos.org/t/fetchtarball-with-multiple-top-level-directories-fails/20556
  mkHostedDependencySource =
    name: details:
    let
      archive = fetchurl {
        name = "pub-${name}-${details.version}.tar.gz";
        url = "${details.description.url}/packages/${details.description.name}/versions/${details.version}.tar.gz";
        sha256 = details.description.sha256;
      };
    in
    runCommand "pub-${name}-${details.version}" { passthru.packageRoot = "."; } ''
      mkdir -p "$out"
      tar xf '${archive}' -C "$out"
    '';

  mkGitDependencySource =
    name: details:
    (fetchgit {
      name = "pub-${name}-${details.version}";
      url = details.description.url;
      rev = details.description.resolved-ref;
      hash =
        gitHashes.${name}
          or (throw "A Git hash is required for ${name}! Set to an empty string to obtain it.");
    }).overrideAttrs
      (
        {
          passthru ? { },
          ...
        }:
        {
          passthru = passthru // {
            packageRoot = details.description.path;
          };
        }
      );

  mkPathDependencySource =
    name: details:
    assert lib.assertMsg details.description.relative
      "Only relative paths are supported - ${name} has an absolue path!";
    (
      if lib.isDerivation src then
        src
      else
        (runCommand "pub-${name}-${details.version}" { } ''cp -r '${src}' "$out"'')
    ).overrideAttrs
      (
        {
          passthru ? { },
          ...
        }:
        {
          passthru = passthru // {
            packageRoot = "${packageRoot}/${details.description.path}";
          };
        }
      );

  mkSdkDependencySource =
    name: details:
    (sdkSourceBuilders.${details.description}
      or (throw "No SDK source builder has been given for ${details.description}!")
    )
      name;

  addDependencySourceUtils =
    dependencySource: details:
    dependencySource.overrideAttrs (
      { passthru, ... }:
      {
        passthru = passthru // {
          inherit (details) version;
        };
      }
    );

  sourceBuilders =
    callPackage ../../../development/compilers/dart/package-source-builders { } // customSourceBuilders;

  dependencySources = lib.filterAttrs (name: src: src != null) (
    builtins.mapAttrs (
      name: details:
      (sourceBuilders.${name} or ({ src, ... }: src)) {
        inherit (details) version source;
        src = (
          (addDependencySourceUtils (
            (
              {
                "hosted" = mkHostedDependencySource;
                "git" = mkGitDependencySource;
                "path" = mkPathDependencySource;
                "sdk" = mkSdkDependencySource;
              }
              .${details.source}
              name
            )
              details
          ))
            details
        );
      }
    ) pubspecLock.packages
  );
in
{
  inherit
    # An attribute set of dependency categories to package name lists.
    dependencies

    # An attribute set of package names to their versions.
    dependencyVersions

    # An attribute set of package names to their sources.
    dependencySources
    ;
}
