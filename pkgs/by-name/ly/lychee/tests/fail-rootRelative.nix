{ runCommand, testers }:
let
  sitePkg = runCommand "site" { } ''
    dist=$out/dist
    mkdir -p $dist
    echo "<html><body>hi</body></html>" > $dist/index.html
    echo "<html><body><a href=\"/index.html\">home</a></body></html>" > $dist/page.html
  '';

  linkCheck = testers.lycheeLinkCheck {
    site = sitePkg + "/dist";
  };

  failure = testers.testBuildFailure linkCheck;

in
runCommand "link-check-fail" { inherit failure; } ''
  grep -F "root-relative-links-are-forbidden-use-relative-links/index.html" $failure/testBuildFailure.log >/dev/null
  grep -F "Please set the relocatable parameter" $failure/testBuildFailure.log >/dev/null
  touch $out
''
