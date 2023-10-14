{ linkFarmFromDrvs, fetchurl }:
{ name, nugetDeps, sourceFile ? null }:
linkFarmFromDrvs "${name}-nuget-deps" (nugetDeps {
  fetchNuGet = { pname, version, sha256
    , url ? "https://www.nuget.org/api/v2/package/${pname}/${version}" }:
    fetchurl {
      name = "${pname}.${version}.nupkg";
      inherit url sha256;
    };
}) // {
  inherit sourceFile;
}
