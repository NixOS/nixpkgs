{ stdenv
, lib
, makeSetupHook
, dieHook
, tests
, cc ? stdenv.cc
, sanitizers ? []
}:

makeSetupHook {
  deps = [ dieHook cc ];

  substitutions = {
    cc = let
      san = lib.escapeShellArgs (map (s: "-fsanitize=${s}") sanitizers);
    in "${cc}/bin/cc ${san}";

    passthru.tests = tests.makeBinaryWrapper;
  };
} ./make-binary-wrapper.sh
