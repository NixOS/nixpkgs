{ lib
, runCommand
# Configuration input
, id
}:
let
  contentFile = (./. + "/content.md");
in {
  inherit id;
  drv = runCommand "FACT_${id}.md" { inherit contentFile; } ''
    cp $contentFile $out
  '';
  target = "./languages-frameworks/python.section.md";
}
