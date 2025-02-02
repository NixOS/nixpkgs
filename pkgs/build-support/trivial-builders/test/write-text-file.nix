/*
  To run:

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeTextFile

  or to run an individual test case

      cd nixpkgs
      nix-build -A tests.trivial-builders.writeTextFile.foo
*/
{ lib, runCommand, runtimeShell, writeTextFile }:
let
  veryWeirdName = ''here's a name with some "bad" characters, like spaces and quotes'';
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
      runCommand "test-writeTextFile-different-exe-name" {} ''
        PATH="${lib.makeBinPath [ pkg ]}:$PATH"
        x=$(foo)
        [[ "$x" == hi ]]
        touch $out
      '';

  weird-name = writeTextFile {
    name = "weird-names";
    destination = "/etc/${veryWeirdName}";
    text = ''passed!'';
    checkPhase = ''
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
