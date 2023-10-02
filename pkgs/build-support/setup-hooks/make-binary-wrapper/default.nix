{ targetPackages
, lib
, makeSetupHook
, dieHook
, writeShellScript
, tests
, cc ? targetPackages.stdenv.cc
, sanitizers ? []
}:

makeSetupHook {
  name = "make-binary-wrapper-hook";
  propagatedBuildInputs = [ dieHook ];

  substitutions = {
    cc = "${cc}/bin/${cc.targetPrefix}cc ${lib.escapeShellArgs (map (s: "-fsanitize=${s}") sanitizers)}";
  };

  passthru = {
    # Extract the function call used to create a binary wrapper from its embedded docstring
    extractCmd = writeShellScript "extract-binary-wrapper-cmd" ''
      ${cc.bintools.targetPrefix}strings -dw "$1" | sed -n '/^makeCWrapper/,/^$/ p'
    '';

    tests = tests.makeBinaryWrapper;
  };
} ./make-binary-wrapper.sh
