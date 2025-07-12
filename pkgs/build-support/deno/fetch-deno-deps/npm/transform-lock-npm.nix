{
  callPackage,
}:
let
  inherit (callPackage ../lib.nix { }) fixHash;

  makeNpmPackageUrl =
    parsedPackageSpecifier:
    let
      # https://registry.npmjs.org/get-stdin/-/get-stdin-8.0.0.tgz
      withScope = "https://registry.npmjs.org/@${parsedPackageSpecifier.scope}/${parsedPackageSpecifier.name}/-/${parsedPackageSpecifier.name}-${parsedPackageSpecifier.version}.tgz";
      # https://registry.npmjs.org/@tokens-studio/sd-transforms/-/sd-transforms-2.0.1.tgz
      withoutScope = "https://registry.npmjs.org/${parsedPackageSpecifier.name}/-/${parsedPackageSpecifier.name}-${parsedPackageSpecifier.version}.tgz";
    in
    if parsedPackageSpecifier.scope != null then withScope else withoutScope;

  makeNpmPackage =
    { parsedPackageSpecifier, hash }:
    {
      hash = fixHash {
        inherit hash;
        algo = "sha512";
      };
      url = makeNpmPackageUrl parsedPackageSpecifier;
      meta = {
        inherit parsedPackageSpecifier;
      };
    };

  makeNpmPackages =
    { npmParsed }:
    let
      npmPackages = (
        builtins.attrValues (builtins.mapAttrs (name: value: makeNpmPackage value) npmParsed)
      );
    in
    {
      withHashPerFile = {
        packagesFiles = npmPackages;
      };
    };
in
{
  inherit makeNpmPackages;
}
