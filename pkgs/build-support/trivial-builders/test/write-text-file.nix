/*
  To run:

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeTextFile

  or to run an individual test case

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeTextFile.foo
*/
{
  lib,
  stdenvNoCC,
  testers,
  runCommand,
  runtimeShell,
  writeTextFile,
}:
lib.makeExtensible (
  final:
  let
    veryWeirdName = ''here's a name with some "bad" characters, like spaces and quotes'';

    test-checkPhase-expectedBuildLogEntries = [ "writeTextFile is executing checkPhase." ];

    test-checkPhase-sample = writeTextFile {
      name = "test-writeTextFile-deprecated-checkPhase-compatibility-sample.txt";
      text = ''
        This test expects `writeTextFile` to handle the deprecated `checkPhase` argument compatibly.
      '';
      checkPhase = ''
        echo "${lib.concatLines test-checkPhase-expectedBuildLogEntries}"
        false
      '';
    };

    test-checkPhase-samples = {
      checkPhase = test-checkPhase-sample;
    }
    // lib.genAttrs [ "preCheck" "postCheck" ] (
      phaseName:
      test-checkPhase-sample.overrideAttrs (previousAttrs: {
        name = lib.replaceString "checkPhase" phaseName previousAttrs.name;
        checkPhase = "";
        ${phaseName} = previousAttrs.checkPhase;
      })
    );

    testNoRepeatScriptText = ''
      REPEATER="repeat-''${REPEATER-}";
      echo "\$REPEATER is now $REPEATER"
      if [[ "$REPEATER" != "repeat-" ]]; then
        echo "ERROR: ''${name-testNoRepeat}: REPEATER is appended more than once."
        exit 1
      fi
    '';
  in
  lib.recurseIntoAttrs {

    different-exe-name =
      let
        pkg = writeTextFile {
          name = "bar";
          destination = "/bin/foo";
          executable = true;
          text = ''
            #!${runtimeShell}
            echo hi
          '';
        };
      in
      assert pkg.meta.mainProgram == "foo";
      assert baseNameOf (lib.getExe pkg) == "foo";
      assert pkg.name == "bar";
      runCommand "test-writeTextFile-different-exe-name" { } ''
        PATH="${lib.makeBinPath [ pkg ]}:$PATH"
        x=$(foo)
        [[ "$x" == hi ]]
        touch $out
      '';

    weird-name = writeTextFile {
      name = "weird-names";
      destination = "/etc/${veryWeirdName}";
      text = "passed!";
      derivationArgs.postInstallCheck = ''
        # intentionally hardcode everything here, to make sure
        # Nix does not mess with file paths

        name="here's a name with some \"bad\" characters, like spaces and quotes"
        fullPath="$out/etc/$name"

        if [ -f "$fullPath" ]; then
          echo "[PASS] File exists!"
        else
          echo "[FAIL] File was not created at expected path!"
          exit 1
        fi

        content=$(<"$fullPath")
        expected="passed!"

        if [ "$content" = "$expected" ]; then
          echo "[PASS] Contents match!"
        else
          echo "[FAIL] File contents don't match!"
          echo "       Expected: $expected"
          echo "       Got:      $content"
          exit 2
        fi
      '';
    };
  }

  // lib.mergeAttrsList (
    map
      (
        phaseName:
        {
          "deprecated-${phaseName}-compatibility" = testers.testBuildFailure' {
            name = "test-writeTextFile-deprecated-${phaseName}-compatibility";
            drv = test-checkPhase-samples.${phaseName};
            expectedBuilderLogEntries = test-checkPhase-expectedBuildLogEntries;
            script = ''
              set -x
              diff -u "$failed/result" <(printf "%s" ${lib.escapeShellArg test-checkPhase-sample.text})
              set +x
            '';
          };

          "deprecated-${phaseName}-no-repeat" = writeTextFile (finalAttrs: {
            name = "test-writeTextFile-deprecated-${phaseName}-no-repeat";
            text = ''
              ${finalAttrs.name}
            '';
            checkPhase = testNoRepeatScriptText;
          });

        }
        //
          lib.mapAttrs'
            (n: v: {
              name = "deprecated-${phaseName}-mitigated-by-${n}";
              value = test-checkPhase-samples.${phaseName}.overrideAttrs (previousAttrs: {
                name = "test-writeTextFile-deprecated-${phaseName}-mitigated-by-${n}";
                ${phaseName} = v;
                passthru = previousAttrs.passthru or { } // {
                  __getDeprecatedCheckPhase-forceThrow = true;
                };
              });
            })
            {
              null = null;
              empty-string = "";
            }
      )
      [
        "checkPhase"
        "preCheck"
        "postCheck"
      ]
  )
  // lib.genAttrs' [ "preCheck" "postCheck" ] (
    phaseName:
    let
      previousName = "deprecated-${phaseName}-no-repeat";
    in
    {
      name = previousName + "-with-checkPhase";
      value = final.${previousName}.overrideAttrs {
        checkPhase = ''
          runHook preCheck
          runHook postCheck
        '';
      };
    }
  )
)
