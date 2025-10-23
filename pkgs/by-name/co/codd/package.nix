{
  lib,
  fetchFromGitHub,
  haskell,
  haskellPackages,
}:

##############
# To upgrade codd you typically only need to change the version, revision and SHA hash
# in this very file.
# If codd's dependencies change, however, clone codd at https://github.com/mzabani/codd,
# checkout the desired tag and run `cabal2nix .` to produce and replace the generated.nix
# file. Finally, do change the version in this file.
##############

let
  # Haxl has relatively tight version requirements and is thus often marked as broken.
  haxlJailbroken = haskell.lib.markUnbroken (haskell.lib.doJailbreak haskellPackages.haxl);

  generated = haskellPackages.callPackage ./generated.nix { haxl = haxlJailbroken; };

  derivationWithVersion = haskell.lib.compose.overrideCabal rec {
    version = "0.1.6";
    src = fetchFromGitHub {
      owner = "mzabani";
      repo = "codd";
      rev = "refs/tags/v${version}";
      hash = "sha256-KdZCL09TERy/PolQyYYykEbPtG5yhxrLZSSo9n6p2WE=";
    };

    # We only run codd's tests that don't require postgresql nor strace. We need to support unix sockets in codd's test suite
    # before enabling postgresql's tests, and SystemResourcesSpecs might fail on macOS because of the need for strace and parsing
    # libc calls. Not that we really gain much from running SystemResourcesSpecs here anyway.
    testFlags = [
      "--skip"
      "/DbDependentSpecs/"
      "--skip"
      "/SystemResourcesSpecs/"
    ];

    isLibrary = false;
    testToolDepends = [ haskellPackages.hspec-discover ];

    description = "CLI tool that applies postgres SQL migrations atomically with schema equality checks";

    homepage = "https://github.com/mzabani/codd";

    changelog = "https://github.com/mzabani/codd/releases/tag/v${version}";

    maintainers = with lib.maintainers; [ mzabani ];
  } generated;
in
haskell.lib.compose.justStaticExecutables derivationWithVersion
