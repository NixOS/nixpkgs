{ stdenv
, lib
, darwin
, makeSetupHook
, dieHook
, tests
, cc ? stdenv.cc
, sanitizers ? []
}:

makeSetupHook {
  deps = [ dieHook ]
    # https://github.com/NixOS/nixpkgs/issues/148189
    ++ lib.optional (stdenv.isDarwin && stdenv.isAarch64) darwin.cctools;

  substitutions = {
    cc = let
      san = lib.escapeShellArgs (map (s: "-fsanitize=${s}") sanitizers);
    in "${cc}/bin/cc ${san}";

    passthru.tests = tests.makeBinaryWrapper;
  };
} ./make-binary-wrapper.sh
