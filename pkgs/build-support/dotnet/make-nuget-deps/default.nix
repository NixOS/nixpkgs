{ linkFarmFromDrvs, fetchurl }:
{ name, nugetDeps ? import sourceFile, sourceFile ? null }:
linkFarmFromDrvs "${name}-nuget-deps" (nugetDeps {
  fetchNuGet = { pname, version, sha256 ? "", hash ? ""
    , url ? "https://www.nuget.org/api/v2/package/${pname}/${version}" }:
    fetchurl {
      name = "${pname}.${version}.nupkg";
      # There is no need to verify whether both sha256 and hash are
      # valid here, because nuget-to-nix does not generate a deps.nix
      # containing both.
      inherit url sha256 hash;
    };
}) // {
  inherit sourceFile;
}
