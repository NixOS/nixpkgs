{
  lib,
  haskell,
  fetchFromGitHub,
}:

let
  # Remove when haskellPackages is on GHC 9.12
  haskellPackages = haskell.packages.ghc912;
in

haskell.lib.compose.justStaticExecutables (
  haskellPackages.callPackage (
    { mkDerivation }:
    mkDerivation {
      pname = "hooky";
      version = "1.0.8";

      src = fetchFromGitHub {
        owner = "brandonchinn178";
        repo = "hooky";
        rev = "31a81c6a699912c5181ce3d38e7981d3e4f279ff";
        hash = "sha256-je5yL8D6JXO7JvxnwyoWkSRqpcx3RynbT9BMx8sfYT8=";
      };

      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends = with haskellPackages; [
        base
        ansi-terminal
        bytestring
        concurrent-output
        containers
        deepseq
        directory
        file-io
        filepath
        Glob
        kdl-hs
        os-string
        process
        scientific
        text
        time
        unliftio
      ];
      executableHaskellDepends = with haskellPackages; [
        base
        containers
        directory
        file-io
        filepath
        optparse-applicative
        process
        text
        unliftio
      ];
      testHaskellDepends = with haskellPackages; [
        base
        directory
        filepath
        process
        skeletest
        temporary
        text
        unliftio
      ];
      doCheck = false;

      homepage = "https://github.com/brandonchinn178/hooky";
      description = "A minimal git hooks manager.";
      maintainers = with lib.maintainers; [ brandonchinn178 ];
      license = lib.licenses.bsd3;
      mainProgram = "hooky";
    }
  ) { }
)
