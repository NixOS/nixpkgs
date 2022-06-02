{ stdenv
, targetPackages
, lib
, makeSetupHook
, dieHook
, writeShellScript
, tests
, cc ? targetPackages.stdenv.cc
, sanitizers ? []
}:

makeSetupHook {
  deps = [ dieHook ]
    # https://github.com/NixOS/nixpkgs/issues/148189
    ++ lib.optional (stdenv.isDarwin && stdenv.isAarch64) cc;

  substitutions = {
    cc = "${cc}/bin/${cc.targetPrefix}cc ${lib.escapeShellArgs (map (s: "-fsanitize=${s}") sanitizers)}";

    # Extract the function call used to create a binary wrapper from its embedded docstring
    passthru.extractCmd = writeShellScript "extract-binary-wrapper-cmd" ''
      strings -dw "$1" | sed -n '/^makeCWrapper/,/^$/ p'
    '';

    passthru.tests = tests.makeBinaryWrapper;
  };
} ./make-binary-wrapper.sh
