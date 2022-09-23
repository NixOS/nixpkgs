{ linkFarmFromDrvs, fetchurl }:
{ name, nugetDeps }:
linkFarmFromDrvs "${name}-nuget-deps" (nugetDeps {
  fetchNuGet = { pname, version, sha256 ? "", hash ? ""
    , url ? "https://www.nuget.org/api/v2/package/${pname}/${version}" }:
    fetchurl {
      name = "${pname}.${version}.nupkg";
      inherit url sha256 hash;
    };
})
