{ callPackage, attrs ? {} }:

let
  overrides = {
    version = "unstable-2017-10-12";

    rev    = "cbecc7766e37f29d50705da0a82dc76ce7c3b86e";
    sha256 = "1wprjas3k14rxfl06mgr0xq2ra735w1c7dq4xrdvii887wnl37xb";
  } // attrs;
in callPackage ./build.nix overrides
