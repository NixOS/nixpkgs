{ symlinkJoin
, fetchurl
, stdenvNoCC
, lib
, unzip
, patchNupkgs
, nugetPackageHook
, fetchNupkg
}:
lib.makeOverridable(
  { name
  , nugetDeps ? import sourceFile
  , sourceFile ? null
  , installable ? false
  }:
  (symlinkJoin {
    name = "${name}-nuget-deps";
    paths = nugetDeps {
      fetchNuGet = args: fetchNupkg (args // { inherit installable; });
    };
  }) // {
    inherit sourceFile;
  })
