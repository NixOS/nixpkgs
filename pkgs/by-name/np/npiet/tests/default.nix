{ fetchurl, callPackage }:
let
  # More examples can be found at https://www.dangermouse.net/esoteric/piet/samples.html
  hello-program = fetchurl {
    url = "https://www.dangermouse.net/esoteric/piet/hw6.png";
    hash = "sha256-E8OMu0b/oU8lDF3X4o5WMnnD1IKNT2YF+qe4MXLuczI=";
  };
  prime-tester-program = fetchurl {
    url = "https://www.bertnase.de/npiet/nprime.gif";
    hash = "sha256-4eaJweV/n73byoWZWCXiMLkfSEhMPf5itVwz48AK/FA=";
  };
  brainfuck-interpreter-program = fetchurl {
    url = "https://www.dangermouse.net/esoteric/piet/piet_bfi.gif";
    hash = "sha256-LIfOG0KFpr4nxAtLLeIsPQl+8Ujyvfz/YnEm/HRoVjY=";
  };
in
{
  hello = callPackage ./run-test.nix {
    testName = "hello";
    programPath = hello-program;
    expectedOutput = "Hello, world!";
  };
  prime = callPackage ./run-test.nix {
    testName = "prime";
    programPath = prime-tester-program;
    programInput = "2069";
    expectedOutput = "Y";
  };
  no-prime = callPackage ./run-test.nix {
    testName = "no-prime";
    programPath = prime-tester-program;
    programInput = "2070";
    expectedOutput = "N";
  };
  brainfuck = callPackage ./run-test.nix {
    testName = "brainfuck";
    programPath = brainfuck-interpreter-program;
    programInput = ",+>,+>,+>,+.<.<.<.|sdhO";
    expectedOutput = "Piet";
  };
}
