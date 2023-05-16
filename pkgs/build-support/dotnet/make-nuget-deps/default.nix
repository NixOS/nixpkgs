{ linkFarmFromDrvs, fetchurl }:
<<<<<<< HEAD
{ name, nugetDeps, sourceFile ? null }:
=======
{ name, nugetDeps }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
linkFarmFromDrvs "${name}-nuget-deps" (nugetDeps {
  fetchNuGet = { pname, version, sha256
    , url ? "https://www.nuget.org/api/v2/package/${pname}/${version}" }:
    fetchurl {
      name = "${pname}.${version}.nupkg";
      inherit url sha256;
    };
<<<<<<< HEAD
}) // {
  inherit sourceFile;
}
=======
})
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
