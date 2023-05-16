<<<<<<< HEAD
{ targetPackages
=======
{ stdenv
, targetPackages
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  propagatedBuildInputs = [ dieHook ];
=======
  propagatedBuildInputs = [ dieHook ]
    # https://github.com/NixOS/nixpkgs/issues/148189
    ++ lib.optional (stdenv.isDarwin && stdenv.isAarch64) cc;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  substitutions = {
    cc = "${cc}/bin/${cc.targetPrefix}cc ${lib.escapeShellArgs (map (s: "-fsanitize=${s}") sanitizers)}";
  };

  passthru = {
    # Extract the function call used to create a binary wrapper from its embedded docstring
    extractCmd = writeShellScript "extract-binary-wrapper-cmd" ''
      strings -dw "$1" | sed -n '/^makeCWrapper/,/^$/ p'
    '';

    tests = tests.makeBinaryWrapper;
  };
} ./make-binary-wrapper.sh
