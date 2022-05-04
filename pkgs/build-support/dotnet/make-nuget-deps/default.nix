{ linkFarmFromDrvs, fetchurl }:
{ name, nugetDeps }:
  linkFarmFromDrvs "${name}-nuget-deps" (nugetDeps {
    fetchNuGet = { pname, version, sha256 }: fetchurl {
      name = "${pname}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${pname}/${version}";
      inherit sha256;
    };
  })
