{ writeTextFile }:
let
  veryWeirdName = ''here's a name with some "bad" characters, like spaces and quotes'';
in writeTextFile {
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
}
