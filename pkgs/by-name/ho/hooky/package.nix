{
  lib,
  haskell,
  fetchFromGitHub,
}:

let
  # TODO: Remove when `haskellPackages` is on GHC 9.12
  haskellPackages = haskell.packages.ghc912;

  # TODO: Remove when hackage2nix is regenerated and `haskellPackages`
  # contains `hooky`
  hookyDrv =
    { mkDerivation }:
    mkDerivation {
      pname = "hooky";
      version = "1.0.9";

      src = fetchFromGitHub {
        owner = "brandonchinn178";
        repo = "hooky";
        rev = "5f44d5ed4ce4c7a7d58b28e3ca94c1d23a52a028";
        hash = "sha256-DTTuYqrsp4M2Nut4zYhq9EMhgG7QG0WeO7wUAgpxTf4=";
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
    };

  haskellPackagesForHooky = haskellPackages.extend (
    final: prev: {
      hooky = final.callPackage hookyDrv { };
      concurrent-output =
        let
          rev = "a40a4d16e7836b56a682779c1ac6882739ba6a9b";
        in
        haskell.lib.compose.overrideSrc {
          version = "${prev.concurrent-output.version}-fork-${rev}";
          src = fetchFromGitHub {
            owner = "brandonchinn178";
            repo = "concurrent-output";
            inherit rev;
            hash = "sha256-tom9+n6VYTzhf4XlIsUlgZz4yfa8Pe45oSiiwEevrsI=";
          };
        } prev.concurrent-output;
    }
  );
in

haskell.lib.compose.justStaticExecutables haskellPackagesForHooky.hooky
