# Check that overriding works for trivial-builders like
# `writeShellScript` via `overrideAttrs`. This is useful
# to override the `checkPhase`, e. g. if you want
# to disable extglob in `writeShellScript`.
#
# Run using `nix-build -A tests.trivial-builders.overriding`.
{
  lib,
  stdenv,
  runtimeShell,
  runCommand,
  callPackage,
  writeShellScript,
  writeTextFile,
  writeShellScriptBin,
}:

let
  extglobScript = ''
    shopt -s extglob
    touch success
    echo @(success|failure)
    rm success
  '';

  simpleCase = case: writeShellScript "test-trivial-overriding-${case}" extglobScript;

  callPackageCase =
    case:
    callPackage (
      { writeShellScript }: writeShellScript "test-trivial-callpackage-overriding-${case}" extglobScript
    ) { };

  binCase = case: writeShellScriptBin "test-trivial-overriding-bin-${case}" extglobScript;

  # building this derivation would fail without overriding
  textFileCase = writeTextFile {
    name = "test-trivial-overriding-text-file";
    checkPhase = "false";
    text = ''
      #!${runtimeShell}
      echo success
    '';
    executable = true;
  };

  disallowExtglob =
    x:
    x.overrideAttrs (_: {
      checkPhase = ''
        ${stdenv.shell} -n "$target"
      '';
    });

  # Run old checkPhase, but only succeed if it fails.
  # This HACK is required because we can't introspect build failures
  # in nix: With `assertFail` we want to make sure that the default
  # `checkPhase` would fail if extglob was used in the script.
  assertFail =
    x:
    x.overrideAttrs (old: {
      checkPhase = ''
        if
          ${old.checkPhase}
        then exit 1; fi
      '';
    });

  mkCase =
    case: outcome: isBin:
    let
      drv = lib.pipe outcome (
        [ case ]
        ++ lib.optionals (outcome == "fail") [
          disallowExtglob
          assertFail
        ]
      );
    in
    if isBin then "${drv}/bin/${drv.name}" else drv;

  writeTextOverrides = {
    # Make sure extglob works by default
    simpleSucc = mkCase simpleCase "succ" false;
    # Ensure it's possible to fail; in this case extglob is not enabled
    simpleFail = mkCase simpleCase "fail" false;
    # Do the same checks after wrapping with callPackage
    # to make sure callPackage doesn't mess with the override
    callpSucc = mkCase callPackageCase "succ" false;
    callpFail = mkCase callPackageCase "fail" false;
    # Do the same check using `writeShellScriptBin`
    binSucc = mkCase binCase "succ" true;
    binFail = mkCase binCase "fail" true;
    # Check that we can also override plain writeTextFile
    textFileSuccess = textFileCase.overrideAttrs (_: {
      checkPhase = "true";
    });
  };

  # `runTest` forces nix to build the script of our test case and
  # run its `checkPhase` which is our main interest. Additionally
  # it executes the script and thus makes sure that extglob also
  # works at run time.
  runTest =
    script:
    let
      name = script.name or (builtins.baseNameOf script);
    in
    writeShellScript "run-${name}" ''
      if [ "$(${script})" != "success" ]; then
        echo "Failed in ${name}"
        exit 1
      fi
    '';
in

runCommand "test-writeShellScript-overriding"
  {
    passthru = { inherit writeTextOverrides; };
  }
  ''
    ${lib.concatMapStrings (test: ''
      ${runTest test}
    '') (lib.attrValues writeTextOverrides)}
    touch "$out"
  ''
