{
  pkgs,
  pandoc-mustache,
  runCommand,
}:
let
  vars = pkgs.writeText "vars.yaml" ''
    place: Montreal
    temperature: '7'
  '';
  markdown = pkgs.writeText "markdown.md" ''
    ---
    title: My Report
    author: Jane Smith
    mustache: ${vars}
    ---
    The temperature in {{place}} was {{temperature}} degrees.
  '';
in
runCommand "pandoc-mustache-test"
  {
    nativeBuildInputs = [
      pandoc-mustache
      pkgs.pandoc
    ];
  }
  ''
    pandoc --filter pandoc-mustache ${markdown} --to plain | grep 'The temperature in Montreal was 7 degrees.' || exit 1
    touch $out
  ''
