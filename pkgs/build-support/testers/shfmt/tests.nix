{ lib, testers }:
lib.recurseIntoAttrs {
  # Positive tests
  indent2 = testers.shfmt {
    name = "indent2";
    indent = 2;
    src = ./src/indent2.sh;
  };
  indent2Bin = testers.shfmt {
    name = "indent2Bin";
    indent = 2;
    src = ./src;
  };
  # Negative tests
  indent2With0 = testers.testBuildFailure' {
    drv = testers.shfmt {
      name = "indent2";
      indent = 0;
      src = ./src/indent2.sh;
    };
  };
  indent2BinWith0 = testers.testBuildFailure' {
    drv = testers.shfmt {
      name = "indent2Bin";
      indent = 0;
      src = ./src;
    };
  };
  indent2With4 = testers.testBuildFailure' {
    drv = testers.shfmt {
      name = "indent2";
      indent = 4;
      src = ./src/indent2.sh;
    };
  };
  indent2BinWith4 = testers.testBuildFailure' {
    drv = testers.shfmt {
      name = "indent2Bin";
      indent = 4;
      src = ./src;
    };
  };
}
