{ stdenv, haskell }:

haskell.packages.ghc865.callPackage
  (
    { mkDerivation
    , base
    , blaze-builder
    , blaze-markup
    , blaze-svg
    , bytestring
    , containers
    , criterion
    , deepseq
    , directory
    , filepath
    , hspec
    , JuicyPixels
    , monads-tf
    , optparse-applicative
    , parallel
    , parsec
    , snap-core
    , snap-server
    , stdenv
    , storable-endian
    , text
    , transformers
    , vector-space
    , fetchFromGitHub
    }:
    let
      version = "0.3.0.0";

      src = fetchFromGitHub {
        owner = "colah";
        repo = "ImplicitCAD";
        rev = "v${version}";
        sha256 = "1v3sja5i7kxjspxcqd2rs7c4h8w6i5j1whsrk1c64w7fi2lr67xw";
      };

      patches = [ ./fix-haddock.patch ];

      postInstall = ''
        rm $out/bin/{Benchmark,docgen}
      '';

    in
    mkDerivation {
      inherit version src patches postInstall;
      pname = "implicitcad";
      isLibrary = true;
      isExecutable = true;
      libraryHaskellDepends = [
        base
        blaze-builder
        blaze-markup
        blaze-svg
        bytestring
        containers
        deepseq
        directory
        filepath
        hspec
        JuicyPixels
        monads-tf
        parallel
        parsec
        storable-endian
        text
        transformers
        vector-space
      ];
      executableHaskellDepends = [
        base
        bytestring
        criterion
        filepath
        optparse-applicative
        snap-core
        snap-server
        text
        vector-space
      ];
      testHaskellDepends = [ base hspec parsec ];
      benchmarkHaskellDepends = [ base criterion parsec ];
      homepage = "http://implicitcad.org/";
      description = "A math-inspired programmatic 2D & 3D CAD system";
      license = stdenv.lib.licenses.agpl3;
      maintainers = with stdenv.lib.maintainers; [ simonvpe ];
    }
  )
{ }
