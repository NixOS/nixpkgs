{
  runCommand,
  testers,
  emptyDirectory,
  jq,
}:
let
  sitePkg = runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body><a href=\"https://example.com/foo\">foo</a></body></html>" > $dist/index.html
    echo "<html><body></body></html>" > $dist/foo.html
  '';
  check = testers.lycheeLinkCheck {
    site = sitePkg + "/dist";
    remap = {
      # Normally would recommend to append a subpath that hints why it's forbidden; see example in docs.
      # However, we also want to test that a package is converted to a string *before*
      # it's tested whether it's a store path. Mistake made during development caused:
      # cannot check URI: InvalidUrlRemap("The remapping pattern must produce a valid URL, but it is not: /nix/store/4d0ix...empty-directory/foo
      "https://example.com" = emptyDirectory;
    };
    extraArgs = [
      "--format"
      "json"
      "--output"
      "${placeholder "out"}"
    ];
  };

  failure = testers.testBuildFailure check;
in
runCommand "link-check-fail"
  {
    nativeBuildInputs = [ jq ];
    inherit failure;
  }
  ''
    # The details of the message might change, but we have to make sure the
    # correct error is reported, so that we know it's not something else that
    # went wrong.
    jq -e '.error_map | to_entries[] | .value[] | select(.url | test("empty-directory/foo")) | .status.text | test("File not found")' $failure/result > /dev/null || {
      echo Lychee output:
      jq . $failure/result
      echo 'Did not find expected error in JSON output. Adjust test if behavior is acceptable. It should find the broken link to non-existent `foo`.'
      exit 1
    }
    touch $out
  ''
