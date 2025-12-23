{
  runCommand,
  testers,
  emptyDirectory,
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
  };

  failure = testers.testBuildFailure check;
in
runCommand "link-check-fail" { inherit failure; } ''
  # The details of the message might change, but we have to make sure the
  # correct error is reported, so that we know it's not something else that
  # went wrong.
  grep 'empty-directory/foo.*Cannot find file' $failure/testBuildFailure.log >/dev/null
  touch $out
''
