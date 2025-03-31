{
  symlinkJoin,
  lib,
  fetchNupkg,
}:
lib.makeOverridable (
  {
    name,
    nugetDeps ? null,
    sourceFile ? null,
    installable ? false,
  }:
  (symlinkJoin {
    name = "${name}-nuget-deps";
    paths =
      let
        loadDeps =
          if nugetDeps != null then
            nugetDeps
          else if lib.hasSuffix ".nix" sourceFile then
            assert (lib.isPath sourceFile);
            import sourceFile
          else
            { fetchNuGet }: builtins.map fetchNuGet (lib.importJSON sourceFile);
      in
      loadDeps {
        fetchNuGet = args: fetchNupkg (args // { inherit installable; });
      };
  })
  // {
    inherit sourceFile;
  }
)
