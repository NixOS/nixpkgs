let
  lib = import ./..;

  inherit (lib)
    fakeHash
    fakeSha256
    fakeSha512
    flip
    functionArgs
    runTests
    ;
  inherit (lib.fetchers) normalizeHash withNormalizedHash;

  testingThrow = expr: {
    expr = with builtins; tryEval (seq expr "didn't throw");
    expected = {
      success = false;
      value = false;
    };
  };

  # hashes of empty
  sri256 = "sha256-d6xi4mKdjkX2JFicDIv5niSzpyI0m/Hnm8GGAIU04kY=";
  sri512 = "sha512-AXFyVo7jiZ5we10fxZ5E9qfPjSfqkizY2apCzORKFVYZaNhCIVbooY+J4cYST00ztLf0EjivIBPPdtIYFUMfzQ==";

  unionOfDisjoints = lib.foldl lib.attrsets.unionOfDisjoint { };

  genTests = n: f: {
    "test${n}AlreadyNormalized" = {
      expr = f { } {
        outputHash = "";
        outputHashAlgo = "md42";
      };
      expected = {
        outputHash = "";
        outputHashAlgo = "md42";
      };
    };

    "test${n}EmptySha256" = {
      expr = f { } { sha256 = ""; };
      expected = {
        outputHash = fakeSha256;
        outputHashAlgo = "sha256";
      };
    };

    "test${n}EmptySha512" = {
      expr = f { hashTypes = [ "sha512" ]; } { sha512 = ""; };
      expected = {
        outputHash = fakeSha512;
        outputHashAlgo = "sha512";
      };
    };

    "test${n}EmptyHash" = {
      expr = f { } { hash = ""; };
      expected = {
        outputHash = fakeHash;
        outputHashAlgo = null;
      };
    };

    "test${n}Sri256" = {
      expr = f { } { hash = sri256; };
      expected = {
        outputHash = sri256;
        outputHashAlgo = null;
      };
    };

    "test${n}Sri512" = {
      expr = f { } { hash = sri512; };
      expected = {
        outputHash = sri512;
        outputHashAlgo = null;
      };
    };

    "test${n}PreservesAttrs" = {
      expr = f { } {
        hash = "aaaa";
        destination = "Earth";
      };
      expected = {
        outputHash = "aaaa";
        outputHashAlgo = null;
        destination = "Earth";
      };
    };

    "test${n}RejectsSha1ByDefault" = testingThrow (f { } { sha1 = ""; });
    "test${n}RejectsSha512ByDefault" = testingThrow (f { } { sha512 = ""; });

    "test${n}ThrowsOnMissing" = testingThrow (f { } { gibi = false; });
  };
in
runTests (unionOfDisjoints [
  (genTests "NormalizeHash" normalizeHash)
  (genTests "WithNormalized" (
    flip withNormalizedHash ({ outputHash, outputHashAlgo, ... }@args: args)
  ))
  {
    testNormalizeNotRequiredEquivalent = {
      expr = normalizeHash { required = false; } {
        hash = "";
        prof = "shadoko";
      };
      expected = normalizeHash { } {
        hash = "";
        prof = "shadoko";
      };
    };

    testNormalizeNotRequiredPassthru = {
      expr = normalizeHash { required = false; } { "ga bu" = "zo meu"; };
      expected."ga bu" = "zo meu";
    };

    testOptionalArg = {
      expr = withNormalizedHash { } (
        {
          outputHash ? "",
          outputHashAlgo ? null,
          ...
        }@args:
        args
      ) { author = "Jacques Rouxel"; };
      expected.author = "Jacques Rouxel";
    };

    testOptionalArgMetadata = {
      expr = functionArgs (
        withNormalizedHash { } (
          {
            outputHash ? "",
            outputHashAlgo ? null,
          }:
          { }
        )
      );
      expected.hash = true;
    };

    testPreservesArgsMetadata = {
      expr = functionArgs (
        withNormalizedHash { } (
          {
            outputHash,
            outputHashAlgo,
            pumping ? true,
          }:
          { }
        )
      );
      expected = {
        hash = false;
        pumping = true;
      };
    };

    testRejectsMissingHashArg = testingThrow (withNormalizedHash { } ({ outputHashAlgo }: { }));
    testRejectsMissingAlgoArg = testingThrow (withNormalizedHash { } ({ outputHash }: { }));
  }
])
