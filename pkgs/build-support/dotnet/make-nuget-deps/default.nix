{ linkFarmFromDrvs, fetchurl, runCommand, zip }:
{ name, nugetDeps ? import sourceFile, sourceFile ? null }:
linkFarmFromDrvs "${name}-nuget-deps" (nugetDeps {
  fetchNuGet = { pname, version, sha256 ? "", hash ? ""
    , url ? "https://www.nuget.org/api/v2/package/${pname}/${version}" }:
    let
      src = fetchurl {
        name = "${pname}.${version}.nupkg";
        # There is no need to verify whether both sha256 and hash are
        # valid here, because nuget-to-nix does not generate a deps.nix
        # containing both.
        inherit url sha256 hash;
      };
    in
    # NuGet.org edits packages by signing them during upload, which makes
    # those packages nondeterministic depending on which source you
    # get them from. We fix this by stripping out the signature file.
    # Signing logic is https://github.com/NuGet/NuGet.Client/blob/128a5066b1438627ac69a2ffe9de564b2c09ee4d/src/NuGet.Core/NuGet.Packaging/Signing/Archive/SignedPackageArchiveIOUtility.cs#L518
    # Non-NuGet.org sources might not have a signature file; in that case, zip
    # exits with code 12 ("zip has nothing to do", per `man zip`).
    runCommand src.name
      {
        inherit src;
        nativeBuildInputs = [ zip ];
      }
      ''
        zip "$src" --temp-path "$TMPDIR" --output-file "$out" --delete .signature.p7s || {
          (( $? == 12 ))
          install -Dm644 "$src" "$out"
        }
      '';
})
// {
  inherit sourceFile;
}
